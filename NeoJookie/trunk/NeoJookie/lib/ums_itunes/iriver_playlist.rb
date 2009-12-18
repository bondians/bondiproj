module UmsItunes
  class IRiverPlaylist
    attr_accessor :name, :tracks
    
    def initialize(user_attributes = {})
      attributes = {
        :name   => 'Playlist',
        :tracks => []
        }.merge(user_attributes)
      
      @name = attributes[:name]
      @tracks = attributes[:tracks]
    end
    
    def to_pla
      output = []
      output << chunkify_header
      tracks.each { |track| output << chunkify_track(track) }
      output.join
    end
    
    def chunkify_header
      output = []
      output << tracks.length
      output << "iriver UMS PLA"
      output << name
      output.pack("Na28a480")
    end
    
    def chunkify_track(track)
      iriver_track = iriverize(track)
      filename_position = get_filename_position(iriver_track)
      
      output = []
      output << filename_position
      output << string_padding(iriver_track)
      output.pack("na510")
    end
    
    def iriverize(data)
      if data.index("\\") == nil
        data = data.gsub(/\/Users\/.*\/iTunes Music\//,'').split("/").unshift("\\Music").join("\\")
      end
      data
    end
    
    def get_filename_position(data)
      data.rindex("\\") + 2 rescue 0
    end
    
    def string_padding(data)
      data.split(//).unshift("").join("\0")
    end
  end
end