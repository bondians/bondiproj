class Artist < ActiveRecord::Base
  has_many :songs

  cattr_reader :per_page
  @@per_page = 10

  def self.search(search, page)
    paginate :per_page => 10, :page => page,
             :conditions => ['name like ?', "%#{search}%"]
  end

  def albums
    self.songs.map{|song| song.album}.uniq
  end
  
end
