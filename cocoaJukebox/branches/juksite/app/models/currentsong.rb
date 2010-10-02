class Currentsong < ActiveRecord::Base
  belongs_to :song
  
  def self.playing
    playing = Currentsong.first :order => :id
    playing ||= Currentsong.new
    return playing.song
  end
  def self.setPlaying (song)
    old = Currentsong.first :order => :id
    old ||= Currentsong.new
    old.song = song
    old.save
  end
end
