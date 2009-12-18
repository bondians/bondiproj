class Album < ActiveRecord::Base
  belongs_to :artist
  belongs_to :genre
  
  has_many :songs
  
  acts_as_ferret :fields => {
        :name         => { :boost => 2   },
        :artist_name  => { :boost => 1.5 },
        :genre_name   => { :boost => 0.2 }
      }

  def artist_name
    artist.name
  end
  
  def genre_name
    genre.name
  end
end
