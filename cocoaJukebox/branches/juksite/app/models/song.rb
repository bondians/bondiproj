class Song < ActiveRecord::Base
  belongs_to :album
  belongs_to :artist
  belongs_to :genre
  belongs_to :songtype
  has_many :plentries
  validates_presence_of :songtype

  cattr_reader :per_page
  @@per_page = 100

  attr_accessor :form_idx
  
  def <=> (other)
    track.to_i <=> other.track.to_i
  end
  
  def formatted_id
    "#{self.id}.#{self.songtype.identifier}"
  end
  
  def album_name
    if album
      album.name
    else
      nil
    end
  end
  
  def artist_name
    if artist
      artist.name
    else
      nil
    end
  end
  
  def genre_name
    if genre
      genre.name
    else
      nil
    end
  end
  
  def songtype_name
    if songtype
      songtype.name
    else
      nil
    end
  end
  
  def to_xml(options = {})
    returning '' do |output|
      xml = options[:builder] ||= Builder::XmlMarkup.new(:target => output, :indent => options[:indent] || 2)
      xml.instruct! unless options[:skip_instruct]
      
      song_opts = { :id => id, :size => size, :volume => volume, :created => created_at, :updated => updated_at }
      if year && year > 0
        song_opts[:year] = year
      end
      if archive_number
        song_opts[:archive_number] = archive_number
      end
      if user_id
        song_opts[:user_id] = user_id
      end
      
      xml.song(song_opts) {
        xml.title(title)
        xml.album(album_name,   :id => album_id, :track => track)
        xml.artist(artist_name, :id => artist_id)
        xml.genre(genre_name,   :id => genre_id)
        xml.type(songtype_name, :id => songtype_id)
        
        if fade_duration > 0
          xml.fade(fade_in, :duration => fade_duration)
        else
          xml.fade(fade_in)
        end
        
        if pre_id
          segue_opts ||= Hash.new
          segue_opts[:comefrom] = pre_id
        end
        if post_id
          segue_opts ||= Hash.new
          segue_opts[:goto] = post_id
        end
        if segue_opts
          xml.segue(segue_opts)
        end
        
        if comments
          xml.comments(comments)
        end
      }
    end
  end
  ## Need to fix this logic, but need stub for now
  def self.padRands
    playlist = Playlist.find(1).songs
    list = playlist.collect{|t| t.id}
    (11 - Randlist.all.length).times do |time|
      new = Randlist.new
      new.song_id = list[rand(list.length)]
      new.save
      new.sort = new.id
      new.save
    end
  end
  
  def self.search(search, page)
    paginate :per_page => 100, :page => page,
             :conditions => ['title like ?', "%#{search}%"],
             :include => [:songtype, :album, :artist, :genre]
  end
end
