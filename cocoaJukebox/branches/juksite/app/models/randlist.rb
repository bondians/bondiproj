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
    more_than_ten = list.length > 10
    (11 - Randlist.count).times do |time|
      new = Randlist.new
      if more_than_ten
        min = [20, (list.length * 0.2).to_i].min
        already_played = (Currentsong.all :order => 'id DESC', :limit => min).map { |s| s.song.id}
        prospective_song = nil
        until (!!prospective_song && (!already_played.include?(prospective_song) ))
          prospective_song = list[rand(list.length)]
        end
        new.song_id = prospective_song
        puts new.song_id
      else
        new.song_id = list[rand(list.length)]
      end
      new.save
      new.sort = new.id
      new.save
    end
  end
end
