class CreateGenres < ActiveRecord::Migration
  class Genre < ActiveRecord::Base
  end
  
  def self.data
    [
      { :id => 1, :genre => "--"},
      { :id => 29, :genre => "Blues"},
      { :id => 30, :genre => "Soundtrack"},
      { :id => 31, :genre => "Unclassifiable"},
      { :id => 32, :genre => "Rock"},
      { :id => 33, :genre => "Country"},
      { :id => 34, :genre => "Pop"},
      { :id => 35, :genre => "New"},
      { :id => 36, :genre => "Classical"},
      { :id => 37, :genre => "Jazz"},
      { :id => 38, :genre => "World"},
      { :id => 39, :genre => "Children's Music"},
      { :id => 40, :genre => "Alternative"},
      { :id => 41, :genre => "Show Tunes"},
      { :id => 42, :genre => "Blues/R&B"},
      { :id => 43, :genre => "Industrial"},
      { :id => 44, :genre => "Electronic"},
      { :id => 45, :genre => "Easy"},
      { :id => 46, :genre => "Dance"},
      { :id => 47, :genre => "Punk"},
      { :id => 49, :genre => "Holiday"},
      { :id => 50, :genre => "Religious"},
      { :id => 51, :genre => "Books & Spoken"},
      { :id => 52, :genre => "Folk"},
      { :id => 53, :genre => "Big Band"},
      { :id => 54, :genre => "Reggae"},
      { :id => 55, :genre => "Classic"},
      { :id => 56, :genre => "Comedy"},
      { :id => 57, :genre => "Hawaiian"},
      { :id => 58, :genre => "Christian"},
      { :id => 59, :genre => "Pink Floyd"},
      { :id => 60, :genre => "Hip Hop/Rap"},
      { :id => 61, :genre => "Sound Clip"},
      { :id => 62, :genre => "Other"},
      { :id => 63, :genre => "Oldies"},
      { :id => 64, :genre => "Ambient"},
      { :id => 65, :genre => "Classic Rock"},
      { :id => 66, :genre => "Techno"},
      { :id => 67, :genre => "Hard Rock"},
      { :id => 68, :genre => "R&B"},
      { :id => 70, :genre => "Folklore"},
      { :id => 71, :genre => "New Age"},
      { :id => 72, :genre => "Easy Listening"},
      { :id => 73, :genre => "Rock & Roll"},
      { :id => 74, :genre => "Old People Music"},
      { :id => 75, :genre => "Trance"},
      { :id => 76, :genre => "House"},
      { :id => 77, :genre => "Data"},
      { :id => 78, :genre => "Speech"},
      { :id => 80, :genre => "Folk/Rock"},
      { :id => 81, :genre => "Club"},
      { :id => 82, :genre => "Electronica/Dance"},
      { :id => 83, :genre => "Metal"},
      { :id => 84, :genre => "Gospel & Religious"},
      { :id => 85, :genre => "Alternative & Punk"},
      { :id => 86, :genre => "Latin"},
      { :id => 87, :genre => "Symphony"},
      { :id => 88, :genre => "Musica Latina"},
      { :id => 89, :genre => "Latin / Rock"},
      { :id => 90, :genre => "Brasil"},
      { :id => 91, :genre => "Latin / Oldies"},
      { :id => 92, :genre => "Latin / Blues"},
      { :id => 93, :genre => "Latin / Salsa"},
      { :id => 94, :genre => "Mariachi"},
      { :id => 95, :genre => "Gospel"},
      { :id => 96, :genre => "Christian Rock"},
      { :id => 97, :genre => "Blues Unclassifiable"},
      { :id => 98, :genre => "Blues Religious"},
      { :id => 99, :genre => "Blues Holiday"},
      { :id => 100, :genre => "Blues Blues/R&B"},
      { :id => 101, :genre => "Blues Hip Hop/Rap"},
      { :id => 102, :genre => "Blues Musica Latina"},
      { :id => 103, :genre => "Blues Electronica/Dance"},
      { :id => 104, :genre => "Blues World"},
      { :id => 105, :genre => "Blues Alternative & Punk"},
      { :id => 106, :genre => "Blues Gospel & Religious"},
      { :id => 107, :genre => "Blues Children's Music"},
      { :id => 108, :genre => "Blues Latin / Oldies"},
      { :id => 109, :genre => "Blues Brasil"},
      { :id => 110, :genre => "Blues rock"},
      { :id => 111, :genre => "Blues Comedy"},
      { :id => 113, :genre => "Blues Old People Music"},
      { :id => 114, :genre => "Blues Latin / Blues"},
      { :id => 115, :genre => "Blues Mariachi"},
      { :id => 116, :genre => "Blues Latin / Salsa"},
      { :id => 117, :genre => "Blues Latin / Rock"},
      { :id => 118, :genre => "Blues Books & Spoken"},
      { :id => 119, :genre => "Blues Christian Rock"},
      { :id => 120, :genre => "Vocal"},
      { :id => 121, :genre => "Bluegrass"},
    ]
  end
  
  def self.up
    create_table :genres do |t|
      t.column :name, :string
    end
    
    add_index :genres, :name, :unique => true
    
    self.data.each do |d|
      Genre.new do |g|
        g.id = d[:id]
        g.name = d[:genre]
        
        g.save
      end
    end
  end
  
  def self.down
    drop_table :genres
  end
end
