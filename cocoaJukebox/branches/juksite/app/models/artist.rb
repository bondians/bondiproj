class Artist < ActiveRecord::Base
  has_many :songs
  has_many :albumartists, :dependent => :destroy
  has_many :albums, :through => :albumartists

  cattr_reader :per_page
  @@per_page = 100

  def self.search(search, page)
    paginate :per_page => 100, :page => page,
             :conditions => ['name like ?', "%#{search}%"]
  end

end
