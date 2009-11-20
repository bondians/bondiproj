# Usage
# require 'tagger'   or "require 'lib/tagger'
# foo = Tagger.new("filename")
# foo.artist  => "Some Artist Guy"

require 'id3lib'
require 'mp4info'
require 'iconv'
require 'lib/dbconst'

class MP4Fixer
  ## This class translates id3lib-ruby calls to the similar call in MP4Info
  def initialize(filename)
    @tag = MP4Info.open(filename)
  end
  
  def title
    @tag.NAM
  end
  
  def album
    @tag.ALB
  end
  
  def artist
    @tag.ART
  end
  
  def genre
    @tag.GNRE
  end
  
  def year
    @tag.DAY.to_i
  end
  
  def track
    @tag.TRKN
  end
  
  def cover
    @tag.COVR
  end
  
  def covertype
    "image/jpeg"
  end
  
end

class Tagger

  TAG_FOR_NAME = { "mp3" => "id3", "m4a" => "aac", "m4p" => "aac"}
  
  def initialize(filename)
    @filename = filename
    namechunks = @filename.split(".")
    @type = Tagger::TAG_FOR_NAME[namechunks.last.downcase]
    
    fail "Unregistered Filetype" unless @type
    
    read_frames
  end
  
  def title
    return convert(@tag.title) if @tag.title
    return DBConstant::NO_TITLE
  end
  
  def artist
    return convert(@tag.artist) if @tag.title
    return DBConstant::NO_ARTIST
  end
  
  def album
    return convert(@tag.album) if @tag.title
    return DBConstant::NO_ALBUM
  end
  
  def genre
    return @tag.genre if @tag.genre
    return DBCONSTANT::NO_GENRE
  end
  
  def year
    return @tag.year.to_i if @tag.year
    return nil
  end
  
  def track
    trk = @tag.track
    return trk.first.to_i if trk.is_a?(Array)
    return trk.split("/").first.to_i if trk.is_a?(String)
    return nil
  end
  
  def type
    return @filename.split(".").last.downcase
  end
  
  def size
    File.size(@filename)
  end
  
  #{:textenc=>0, :data=>"###############scads of data###########", :description=>"", :imageformat=>"", :mimetype=>"image/jpeg", :id=>:APIC, :picturetype=>3}
  def cover
    @tag.find {|f| f[:id] == :APIC }[:data]
  end
  
  def covertype
    @tag.find {|f| f[:id] == :APIC }[:mimetype]
  end
  
  def lookup_genre
    genre_tag = self.genre
    if genre_tag.match(/^\(\d+\)$/)
        num = genre_tag.gsub("(","").gsub(")","").to_i
        genre_tag = DBConstant::GENRES[num]
    end
    
    return genre_tag
  end
  
  private

  def convert(string)
    out = Iconv.conv('UTF-8', 'LATIN1', string)
    out = Iconv.conv('UTF-8', 'UTF-16', string) unless !!out.match(/[a-zA-Z][a-zA-Z]/)
    return out
  end
  
  def read_frames
    self.send("read_frames_#{@type}")
  end
  
  def read_frames_id3
    @tag = ID3Lib::Tag.new(@filename)
  end
  
  def read_frames_aac
    @tag = MP4Fixer.new(@filename)
  end
  
end
