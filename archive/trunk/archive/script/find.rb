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

DEFAULTS = {:volume => 0.7, :fade_duration => -1, :fade_in => true}

### Important models, all have Timestamps plus whatever is below.
#=> Artist (id: integer, name: string)
#=> Genre  (id: integer, name: string)
#=> Album  (id: integer, name: string, artist_id: integer, genre_id: integer)
#=> Song   (id: integer, name: string, track: integer, year: integer, album_id: integer, artist_id: integer,
#        genre_id: integer, comments: text, size: integer, pre_id: integer, post_id: integer, fade_duration: float,
#        volume: float, fade_in: boolean, user_id: integer, archive_number: integer, file: text)
###

  Find.find(ARGV.shift) do |path|
      if FileTest.file?(path)
        kind = path.split(".")
        case kind.last
            when "mp3"
              tag = ID3Lib::Tag.new(path)
              
                ##Build a song object, while working with the rest
                attributes = DEFAULTS
                attributes[:title] = tag.title ? Iconv.conv('UTF-8', 'LATIN1', tag.title) : "<no title>"
                attributes[:size] = tag.size.to_i
                attributes[:year] = tag.year.to_i
                attributes[:file] = path
                
                track = tag.track ? tag.track.split("/").first.to_i : nil
                
                ## Try to find old archive _id
                tag_text = tag.find{|t| t[:id]==:TXXX}
                attributes[:archive_number] = tag_text[:text] if tag_text
                if !!!Song.find_by_archive_number(attributes[:archive_number])
                    
                    #### Try to find each of the rest of the important fields
                    ##Artist
                    artist_tag = tag.artist ? Iconv.conv('UTF-8', 'LATIN1', tag.artist) : "<no artist>"
                    artist = Artist.find_by_name(artist_tag) || Artist.new({:name=>artist_tag})
                    artist.save if artist.new_record?
                    attributes[:artist] = artist
                    
                    ##Genre
                    genre_tag  =  tag.genre ? Iconv.conv('UTF-8', 'LATIN1', tag.genre) : "Unclassifiable"
                    genre = Genre.find_by_name(genre_tag) || Genre.new({:name=>genre_tag})
                    genre.save if genre.new_record?
                    attributes[:genre] = genre
                    
                    ##Album
                    album_tag  =  tag.album ? Iconv.conv('UTF-8', 'LATIN1', tag.album) : "<no album>"
                    album = Album.find_by_name(album_tag) || Album.new({:name=>album_tag, :genre=> genre})
                    album.save if album.new_record?
                    attributes[:album] = album
                    
                    song = Song.new(attributes)
                    if song.save
                        puts "Saved MP3 Titled #{attributes[:title]}"
                    else
                        puts "Saved MP3 Titled #{attributes[:title]}"
                    end
                else
                    puts "Song in DB #{attributes[:title]}"
                end
 
            when "m4a"
                puts "m4a"
                #puts "#{path} is a m4a !!"
            when "m4p"
                puts "m4p"
                #puts "#{path} is a mp4 !!"
        else
            puts "unknown"
            #puts "#{path} is some other shit!!"
        end
      else
        puts "."
    end
  end
    
 