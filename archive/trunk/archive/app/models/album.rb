class Album < ActiveRecord::Base
  has_many :songs
  
  define_index do
    indexes :name, :sortable => true
    indexes artist.name, :as => :artist, :sortable => true
    indexes genre.name, :as => :genre, :sortable => true
  end
  
  def genre
    self.songs.map{|song| song.genre}.first
  end
  
  def artists
    self.songs.map{|song| song.artist}.uniq || []
  end
  
end
