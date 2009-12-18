module UmsItunes
  class Track
    attr_reader :data
    
    def initialize(plist, track_id)
      @data = plist["Tracks"][track_id.to_s]
      raise "Failed to parse tracks from plist" unless @data
    end
    
    def track_id
      @data["Track ID"]
    end
    
    def track_number
      @data["Track Number"]
    end
    
    def name
      @data["Name"]
    end
    
    def artist
      @data["Artist"]
    end
    
    
    def album
      @data["Album"] 
    end
    
    def size
      @data["Size"]
    end
    
    def pid
      @data["Persistent ID"]
    end
    
    def self.location_to_path(file_url)
      File.join(URI::unescape(file_url.gsub(/file:\/\/localhost/, '')).split("/"))
    end
    
    def location
      Track.location_to_path(@data["Location"])
    end
    
    def filename
      File.split(location).last
    end
    
    def destination(base_folder = "") 
      if @destination == nil
        if is_compilation?
          @destination = File.join(base_folder, "Compilations", escaped_album)
        elsif is_podcast?
          @destination = File.join(base_folder, "Podcasts", escaped_album)
        else
          @destination = File.join(base_folder, escaped_artist, escaped_album)
        end
      end
      
      @destination
    end
    
    def destination_file(base_folder = "")
      if @destination_file == nil
        @destination_file = File.join(destination(base_folder), escaped_filename)
      end
      @destination_file
    end
    
    def is_podcast?
      @data["Podcast"] != nil
    end
    
    def is_compilation?
      @data["Compilation"] != nil
    end
    
    def size_mb
      (size / 1024.0).round
    end
    
    def size_kb
      (size / 1048576.0)
    end
    
    def self.escape(string)
      string.gsub(/[\+]/, "_")
    end
    
    def escape(string)
      Track.escape(string)
    end
    
    def escaped_album
      if @escaped_album == nil
        @escaped_album = escape(album)
      end
      @escaped_album
    end
    
    def escaped_artist
      if @escaped_artist == nil
        @escaped_artist = escape(artist)
      end
      @escaped_artist
    end

    def escaped_filename
      if @escaped_filename == nil
        @escaped_filename = escape(filename)
      end
      @escaped_filename
    end
  end
end