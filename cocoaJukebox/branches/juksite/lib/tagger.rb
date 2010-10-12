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
    return "image/jpeg" if @tag.cover
    nil
  end

  def legacy_num
   return nil
  end
  
end

class Tagger

  TAG_FOR_NAME = { "mp3" => "id3", "m4a" => "aac", "m4p" => "aac"}
  
  def self.valid?(filename)
    @filename = filename
    return false if filename.match(".AppleDouble")
    namechunks = @filename.split(".")
    return !!Tagger::TAG_FOR_NAME[namechunks.last.downcase]
  end
  
  def initialize(filename)
    @filename = filename
    namechunks = @filename.split(".")
    @filetype = Tagger::TAG_FOR_NAME[namechunks.last.downcase]
    
    fail "Unregistered Filetype" unless @filetype
    
    read_frames
  end
  
  def title=(text)
    return nil unless self.filetype == "mp3"
    (text = DBConstant::NO_TITLE) if text == ""
    @tag.title=(text)
  end

  def artist=(text)
    return nil unless self.filetype == "mp3"
    (text = DBConstant::NO_ARTIST) if text == ""
    @tag.artist=(text)
  end
  
  def album=(text)
    return nil unless self.filetype == "mp3"
    (text = DBConstant::NO_ALBUM) if text == ""
    @tag.album=(text)
  end
  
  def saveChanges
    return nil unless self.filetype == "mp3"
    @tag.update!
  end
  
  def title
    return convert(@tag.title) if @tag.title
    return DBConstant::NO_TITLE
  end

  def legacy_num
    return nil unless @filetype == 'id3';
    tagText = @tag.find{|t| t[:id]==:TXXX}
    return tagText[:text].to_i if tagText 
    return nil
  end
  
  def artist
    return convert(@tag.artist) if @tag.artist
    return DBConstant::NO_ARTIST
  end
  
  def album
    return convert(@tag.album) if @tag.album
    return DBConstant::NO_ALBUM
  end
  
  def genre
    mygenre = @tag.genre
    return DBConstant::NO_GENRE unless !!mygenre
    mygenre
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
  
  def filetype
    return @filename.split(".").last.downcase
  end
  
  def size
    File.size(@filename)
  end
  
  #{:textenc=>0, :data=>"###############scads of data###########", :description=>"", :imageformat=>"", :mimetype=>"image/jpeg", :id=>:APIC, :picturetype=>3}
  def cover
    return @tag.cover if @tag.respond_to?('cover')
    cov = @tag.find {|f| f[:id] == :APIC }
    return cov[:data] if cov
    nil
  end
  
  def covertype
    return @tag.covertype if @tag.respond_to?('covertype')
    cov = @tag.find {|f| f[:id] == :APIC }
    return "image/jpeg" if cov
    nil
  end
  
  def lookup_genre
    genre_tag = self.genre
    if genre_tag.match(/^\(\d+\)$/)
        num = genre_tag.gsub("(","").gsub(")","").to_i
        genre_tag = DBConstant::GENRES[num]
    end
    
    return convert(genre_tag)
  end
  
  private

  def convert(string)
    out = Iconv.conv('UTF-8', 'LATIN1', string)
    return out if string.length == 1
    out = Iconv.conv('UTF-8', 'UTF-16', string) unless !!out.match(/[[:print:]]{2,}/)
    return out
  end
  
  def read_frames
    self.send("read_frames_#{@filetype}")
  end
  
  def read_frames_id3
    @tag = ID3Lib::Tag.new(@filename)
  end
  
  def read_frames_aac
    @tag = MP4Fixer.new(@filename)
  end
  
end
