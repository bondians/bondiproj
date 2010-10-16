class Album < ActiveRecord::Base
  has_many :songs
  has_many :artists, :through => :songs
  
  define_index do
    indexes :name, :sortable => true
    indexes artist.name, :as => :artist, :sortable => true
    indexes genre.name, :as => :genre, :sortable => true
  end
  
  def genre
    self.songs.select{|song| song.genre}.first
  end
  
end
