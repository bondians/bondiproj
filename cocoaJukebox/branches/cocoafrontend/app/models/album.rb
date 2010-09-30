class Album < ActiveRecord::Base
  belongs_to :genre
  has_many :albumartists, :dependent => :destroy
  has_many :artists, :through => :albumartists
  has_many :songs
  
  define_index do
    indexes :name, :sortable => true
    indexes artist.name, :as => :artist, :sortable => true
    indexes genre.name, :as => :genre, :sortable => true
  end
  
  
end
