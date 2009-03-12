#!/usr/bin/env ruby

require File.expand_path(__FILE__ + "/../../config/environment")

data = IO.readlines("#{RAILS_ROOT}/oldplaylists.txt")

data.each do |line|
  (archive, list, title) = line.split("|")
  (listuser, listname) = list.split(".")
  listname ||= "Favorites"
  
end

# 192264|cayuse.country|Tiny Broken Heart
# 192267|cayuse.country|Stay
# 192269|cayuse.country|Ghost in This House
# 192271|cayuse.country|Forget About It