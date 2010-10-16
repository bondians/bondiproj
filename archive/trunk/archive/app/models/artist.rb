class Artist < ActiveRecord::Base
  has_many :songs
  
  define_index do
    indexes :name, :sortable => true
  end

  def albums
    self.songs.map{|song| song.album}.uniq
  end
  
end
