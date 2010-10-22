class Randlist < ActiveRecord::Base
  belongs_to :song
  
  ## Need to fix this logic, but need stub for now
  def self.padRands
    #playlist = Playlist.find(1).songs
    playlist = Playlist.find_all_by_active true
    if playlist.empty?
      playlist = Playlist.all
    end
    list = playlist.collect {|a| a.song_ids}.flatten
    (11 - Randlist.count).times do |time|
      new = Randlist.new
      new.song_id = list[rand(list.length)]
      new.save
      new.sort = new.id
      new.save
    end
  end
end
