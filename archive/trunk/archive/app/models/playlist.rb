class Playlist < ActiveRecord::Base

  belongs_to :user, :class_name=>"Goldberg::User", :foreign_key => :user_id
  has_many :plentries
  has_many :songs, :through => :plentries
  
  attr_accessible :name
  
  def self.add_songs_for_list(songs, playlist)
    debugger
    1
    1
    
  end
end
