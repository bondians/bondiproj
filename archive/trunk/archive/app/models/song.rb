class Song < ActiveRecord::Base
  belongs_to :album
  belongs_to :artist
  belongs_to :genre
  belongs_to :songtype
  
  def self.search(search, page)
    paginate :per_page => 100, :page => page,
             :conditions => ['title like ?', "%#{search}%"],
             :include => [:genre, :artist, :album]
  end
  
end
