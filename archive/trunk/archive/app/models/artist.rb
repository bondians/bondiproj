class Artist < ActiveRecord::Base
  has_many :songs
  has_many :albums, :through => :songs
  
  define_index do
    indexes :name, :sortable => true
  end
  
end
