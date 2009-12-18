module UmsItunes
  class Playlist
    attr_accessor :name
    attr_accessor :tracks
    
    def initialize(name = nil, tracks = nil)
      @name = name || "Playlist"
      @tracks = tracks || []
    end
    
    def self.create_from_plist(plist)
      playlists = []
      
      plist['Playlists'].each_with_index do |playlist, index|
        playlists << Playlist.get_tracks(plist, index)
      end
          
      playlists
    end
    
    def self.get_tracks(plist, index)
      playlist = self.new(plist["Playlists"][index]["Name"])
      
      items = plist["Playlists"][index]["Playlist Items"]
      if items
        items.each do |playlist_item|
          playlist.tracks << Track.new(plist, playlist_item["Track ID"])
        end
      end
      
      playlist
    end
    
    def size(reload = false)
      if @size == nil || reload
        @size = tracks.map { |t| t.size }.inject { |a,b| a + b }
      end
      @size
    end
    
    def size_mb(reload = false)
      (size(reload) / 1024.0).round
    end
    
    def size_kb(reload = false)
      (size(reload) / 1048576.0)
    end
    
    def to_pla(reload = false)
      if @to_pla == nil || reload == true
        iriver_playlist = IRiverPlaylist.new({
          :name => name,
          :tracks => tracks.map { |t| t.location }
          })
        @to_pla = iriver_playlist.to_pla
      end
      
      @to_pla
    end
  end
end