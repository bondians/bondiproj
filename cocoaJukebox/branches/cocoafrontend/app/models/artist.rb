class Artist < ActiveRecord::Base
  has_many :songs
  has_many :albumartists, :dependent => :destroy
  has_many :albums, :through => :albumartists
  
  define_index do
    indexes :name, :sortable => true
  end
  
end
