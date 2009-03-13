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
  
end
