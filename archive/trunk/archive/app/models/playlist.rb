class Playlist < ActiveRecord::Base
  belongs_to :goldberg_user
  has_many :plentries
  
  attr_accessible :name
end
