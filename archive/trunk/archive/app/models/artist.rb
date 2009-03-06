class Artist < ActiveRecord::Base
  has_many :songs
  has_many :albums
  
  define_index do
    indexes :name, :sortable => true
  end
  
end
