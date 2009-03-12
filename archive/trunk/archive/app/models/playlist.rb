class Playlist < ActiveRecord::Base

  belongs_to :user, :class_name=>"Goldberg::User", :foreign_key => :user_id
  has_many :plentries
  has_many :songs, :through => :plentries
  
  attr_accessible :name
end
