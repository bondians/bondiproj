class Song < ActiveRecord::Base
  validates_presence_of :name
  
  validates_presence_of :file_path
  validates_uniqueness_of :file_path
  
  belongs_to :album
  belongs_to :artist
  belongs_to :genre
  
  has_one :intro, :dependent => true
  has_one :segue, :dependent => true
  
  has_and_belongs_to_many :playlists
  
  acts_as_ferret :fields => {
        :name         => { :boost => 2   },
        :comments     => { :boost => 2   },
        :artist_name  => { :boost => 2.5 },
        :album_name   => { :boost => 2   },
        :genre_name   => { :boost => 0.2 }
      }
  
  # local accessors for full-text-indexed cross-references
  def artist_name
    artist.name
  end
  
  def album_name
    album.name
  end
  
  def genre_name
    genre.name
  end
  
  # closure: list of all songs that are to be played when this one is
  #  this includes intros and segues
  def preClosure(withSelf = true)
    closure = []
    
    if intro
      closure << intro.intro.preClosure
    end
    
    if withSelf
      closure << self
    end
    
    closure
  end
  
  def postClosure(withSelf = true)
    closure = []
    
    if withSelf
      closure << self
    end
    
    if segue
      closure << segue.segue_to.postClosure
    end
    
    closure
  end
  
  def closure
    closure = []
    
    if intro
      closure << intro.intro.preClosure
    end
    
    closure << self
    
    if segue 
      closure << segue.segue_to.postClosure
    end
    
    closure.flatten
    closure
  end
end
