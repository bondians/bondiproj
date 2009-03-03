#!/usr/bin/env ruby

require File.expand_path(__FILE__ + "/../../config/environment")

require 'find'
require 'id3lib'
require 'mp4info'
require 'ruby-debug'
require 'Tagit'

@genres = Genre.all
@artists = Artist.all
@albums = Album.all
@songs = Song.all


  Find.find(ARGV.shift) do |path|
      if FileTest.file?(path)
        kind = path.split(".")
        case kind.last
            when "mp3"
                mp3 = ID3Lib::Tag.new(path) || []
                debugger
                1
                1
                tags = mp3.inject({}){ |info, m| m.merge(tagit.read_tag(m)) }
                
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
    
 