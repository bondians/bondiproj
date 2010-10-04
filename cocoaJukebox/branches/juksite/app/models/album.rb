class Album < ActiveRecord::Base
  belongs_to :genre
  has_many :albumartists, :dependent => :destroy
  has_many :artists, :through => :albumartists
  has_many :songs
  

  cattr_reader :per_page
  @@per_page = 100
  
  def self.search(search, page)
    paginate :per_page => 100, :page => page,
             :conditions => ['name like ?', "%#{search}%"]
  end

end
