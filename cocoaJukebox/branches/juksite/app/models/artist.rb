class Artist < ActiveRecord::Base
  has_many :songs
  has_many :albumartists, :dependent => :destroy
  has_many :albums, :through => :albumartists

  
end
