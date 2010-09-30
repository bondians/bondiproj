class Album < ActiveRecord::Base
  belongs_to :genre
  has_many :albumartists, :dependent => :destroy
  has_many :artists, :through => :albumartists
  has_many :songs
  
  
end
