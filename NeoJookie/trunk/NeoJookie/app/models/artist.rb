class Artist < ActiveRecord::Base
  has_many :albums
  has_many :songs
  
  has_many :genres, :through => :songs, :select => "distinct genres.*"
  
  acts_as_ferret
end
