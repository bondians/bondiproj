module UmsItunes
  class FileCopier
    include FileUtils
  
    attr_reader :source
    attr_reader :destination
    attr_reader :manifest
    attr_reader :playlists
    attr_reader :events
    attr_reader :track_queue

    MUSIC_FOLDER      = "Music"
    PLAYLISTS_FOLDER  = "Playlists"
    MANIFESTS_FOLDER  = "Manifests"
  
    def initialize(source_plist, destination_folder)
      @source = Plist::parse_xml(source_plist)
      @events = FileCopier::Events.new
      
      raise(Errno::ENOENT, "The destination folder does not exist") unless @destination = Dir.new(destination_folder)
      
      @playlists = Playlist.create_from_plist(@source)
      
      mkdir_p(File.join(@destination.path, MANIFESTS_FOLDER))
      @manifest = YAML::load_file(File.join(destination_folder, MANIFESTS_FOLDER, "#{@playlists.first.name}.yml")) rescue false
      @manifest = [] unless @manifest
      
      @track_queue = []
    end
    
    def commit  
      mkdir_p(File.join(@destination.path, PLAYLISTS_FOLDER))
      
      events.register("queue_create") do
        @playlists.each do |playlist|
          copy_pla_to_destination(playlist)
          playlist.tracks.each do |track|
            @track_queue << track
          end
        end
      end
      
      # Compare tracks
      tracks_to_delete = rebuild_manifest_from_queue
      
      # Delete unneccessary tracks
      delete_tracks_from_destination(tracks_to_delete)
      
      # Copy tracks
      events.register("tracks_copy") do
        @track_queue.each do |track|
          copy_track_to_destination(track)
        end
      end
    end
    
    def rebuild_manifest_from_queue(manifest = @manifest, queue = @track_queue)
      tracks_to_delete = []
      
      events.register("manifest_rebuild") do
        unless manifest.empty? || queue.empty?
          queue_pids = queue.map { |q| q.pid }
          manifest.each do |track|
            tracks_to_delete << track unless queue_pids.include?(track.pid)
          end
        end
        write_new_manifest_to_destination
      end
      
      return tracks_to_delete
    end
    
    def write_new_manifest_to_destination(track_queue = @track_queue, destination = @destination.path)
      events.register("manifest_write") do
        File.open(File.join(destination, MANIFESTS_FOLDER, "#{@playlists.first.name}.yml"), "w") do |f|
          f.write(track_queue.to_yaml)
        end
      end
    end
    
    def delete_tracks_from_destination(tracks)
      events.register("tracks_delete", tracks) do
        tracks.each do |track|
          events.register("track_delete", track) do
            rm(track.destination_file(File.join(@destination.path, MUSIC_FOLDER))) rescue nil
          end
        end
      end
    end
    
    def copy_track_to_destination(track)
      events.register("track_copy", track) do
        destination_file = track.destination_file(File.join(@destination.path, MUSIC_FOLDER))
        destination      = track.destination(File.join(@destination.path, MUSIC_FOLDER))
        mkdir_p destination unless File.exist?(destination)

        cp(track.location, destination) unless File.exists?(destination_file) && (File.size(destination_file) == File.size(track.location))
      end
    end
    
    def copy_pla_to_destination(playlist)
      events.register("playlist_copy", playlist) do
        destination_file = File.join(@destination.path, PLAYLISTS_FOLDER)
        File.open("#{destination_file}/#{playlist.name}.pla", "w+") do |f|
          f.write(playlist.to_pla)
        end
      end
    end

    def playlists_size(reload = false)
      if @playlists_size == nil || reload
        @playlists_size = playlists.map { |p| p.size(reload) }.inject { |a,b| a + b }
      end
      @playlists_size
    end
    
    def playlists_size_kb(reload = false)
      (playlists_size(reload) / 1024.0).round
    end
    
    def playlists_size_mb(reload = false)
      (playlists_size(reload) / 1048576.0).round
    end
        
    class Events
      def initialize
        events_to_register = %w(
          track_copy
          track_delete
          tracks_copy
          tracks_delete
          queue_create
          playlist_copy
          manifest_write
          manifest_rebuild
        )
        events_to_register.each do |event_name|
          Events.class_eval do
            attr_accessor "#{event_name}_start".intern
            attr_accessor "#{event_name}_end".intern
          end
        end
      end
    
      def register(event_name, event_object = nil)
        trigger("#{event_name}_start".intern, event_object)
        yield
        trigger("#{event_name}_end".intern, event_object)
      end

      
      def trigger(event_name, object)
        event = self.send(event_name)
        send(event_name).call(object) if event.is_a?(Proc)
      end
    end
  end
end