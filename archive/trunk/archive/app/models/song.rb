class Song < ActiveRecord::Base
  belongs_to :album
  belongs_to :artist
  belongs_to :genre
  belongs_to :songtype
  validates_presence_of :songtype
  
  define_index do
    indexes title
    indexes album.name, :as => :album, :sortable => true
    indexes artist.name, :as => :artist, :sortable => true
    indexes genre.name, :as => :genre, :sortable => true
  end
  
end
