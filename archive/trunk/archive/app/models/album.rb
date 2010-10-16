class Album < ActiveRecord::Base
  has_many :songs
  
  define_index do
    indexes :name, :sortable => true
    indexes artist.name, :as => :artist, :sortable => true
    indexes genre.name, :as => :genre, :sortable => true
  end
  
  def genre
    songs.map{|song| song.genre}.first
  end
  
  def artists
    arts = songs.map{|song| song.artist}.uniq
    if arts.empty?
      arts.push Artist.new
    end
  end
  
end
