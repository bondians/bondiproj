#!/usr/bin/env ruby

require ("#{RAILS_ROOT}/config/environment")

data = IO.readlines("#{RAILS_ROOT}/oldplaylists.txt")

playlists = Playlist.all :include=>:user

users = Goldberg::User.all

data.each do |line|
  (archive, list, title) = line.split("|")
  (listuser, listname) = list.split(".")
  listname ||= "Favorites"
  
  if listname == "nidor"
    listuser = "nidor"
  end
  
  
  song = Song.find_by_archive_number archive
  if song
    user = users.find{|u| u.name == listuser}
    if user  
      playlist = playlists.find{|p| p.user.name == listuser && p.name == listname}
      unless playlist
        playlist = Playlist.new
        playlist.user = user
        playlist.name = listnam
        playlist.save
        playlists.unshift(playlist)
      end
      pl = playlist.plentry.build
      pl.song = song
      pl.save
    else
      puts "no user: #{line}"
    end
  else
    puts "no song: #{line}"
  end
end

# 192264|cayuse.country|Tiny Broken Heart
# 192267|cayuse.country|Stay
# 192269|cayuse.country|Ghost in This House
# 192271|cayuse.country|Forget About It