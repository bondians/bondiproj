class Playlist < ActiveRecord::Base
  
  include Goldberg::Model
  
  belongs_to :user 
  has_many :plentries
  
  attr_accessible :name
end
