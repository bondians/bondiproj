#!/usr/bin/env ruby

require File.expand_path(__FILE__ + "/../../config/environment")

require 'find'
require 'id3lib'
require 'mp4info'
require 'ruby-debug'

@genres = Genre.all
@artists = Artist.all
@albums = Album.all
@songs = Song.all


  Find.find(ARGV.shift) do |path|
      if FileTest.file?(path)
        kind = path.split(".")
        case kind.last
            when "mp3"
                tag = ID3Lib::Tag.new(path) || []
                debugger
                1
                1
                
                #tag.title  #=> "Talk"
                #tag.album = 'X&Y'
                #tag.track = '5/13'
                
            when "m4a"
                puts "#{path} is a m4a !!"
            when "m4p"
                puts "#{path} is a mp4 !!"
            else
                puts "#{path} is some other shit!!"
        end
      else
        puts "#{path} is not a file"
    end
  end
    
 