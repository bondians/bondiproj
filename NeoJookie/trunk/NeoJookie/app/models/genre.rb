class Genre < ActiveRecord::Base
  has_many :albums
  has_many :songs
  
  has_many :artists, :through => :songs, :select => "distinct artists.*"
  
  acts_as_ferret
end
