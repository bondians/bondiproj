class Genre < ActiveRecord::Base
  has_many :albums
  has_many :songs
  
  define_index do
    indexes :name, :sortable => true
  end
  
  
end
