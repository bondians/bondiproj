class Album < ActiveRecord::Base
  belongs_to :artist
  belongs_to :genre
  has_many :songs
  
  define_index do
    indexes :name, :sortable => true
  end
  
  
end
