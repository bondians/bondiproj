class Song < ActiveRecord::Base
  belongs_to :album
  belongs_to :artist
  belongs_to :genre
  
  def self.search(search, page)
    paginate :per_page => 100, :page => page,
             :conditions => ['title like ?', "%#{search}%"],
             :order => 'sort', :include => [:genre, :artist, :album]
  end
  
end
