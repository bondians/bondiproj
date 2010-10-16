class Album < ActiveRecord::Base
  has_many :songs
  

  cattr_reader :per_page
  @@per_page = 10
  
  def self.search(search, page)
    paginate :per_page => 10, :page => page,
             :conditions => ['name like ?', "%#{search}%"]
  end

  def genre
    self.songs.map{|song| song.genre}.first
  end
  
  def artists
    self.songs.map{|song| song.artist}.uniq
  end

end
