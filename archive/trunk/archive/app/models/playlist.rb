class Playlist < ActiveRecord::Base

  belongs_to :user, :class_name=>"Goldberg::User", :foreign_key => :user_id
  has_many :plentries
  has_many :songs, :through => :plentries
  
  attr_accessible :name
  
  def self.add_songs_to_playlist(songs, plist)
    playlist = Playlist.find plist
    return unless Goldberg.user.playlists.include?(playlist)
    
    songs.each do |s|
      song = Song.find s
      pl = playlist.plentries.build
      pl.song = song
      pl.save
    end
  end
  
  def self.remove_songs_from_playlist(songs, plist)
    playlist = Playlist.find plist, :include=>[:plentries, :songs]
    
    return unless Goldberg.user.playlists.include?(playlist)
    
    songs.each do |song|
      entry = playlist.plentries.select{|p| p.song.id == song.to_i}.first
      entry.destroy if entry
    end
  end
  
  def to_xml(options = {})
    returning '' do |output|
      xml = options[:builder] ||= Builder::XmlMarkup.new(:target => output, :indent => options[:indent] || 2)
      xml.instruct! unless options[:skip_instruct]
      
      xml.playlist(:id => id, :name => name, :created => created_at, :updated => updated_at) {
        if (user != nil) 
          xml.owner(user.name, :id => user_id)
        end
        xml.songs {
          @songs.each do |song|
            song.to_xml(:builder => xml, :skip_instruct => true)
          end
        }
      }
    end
  end
  
end
