#!/usr/bin/env ruby

require File.expand_path(__FILE__ + "/../../config/environment")
require "#{RAILS_ROOT}/lib/tagger"

require 'find'
require 'id3lib'
require 'mp4info'
require 'ruby-debug'
require "getopt/long"
    opt = Getopt::Long.getopts(
        ["--full", "-f", Getopt::BOOLEAN],
        ["--path", "-p", Getopt::REQUIRED],
        ["--cull", "-c", Getopt::BOOLEAN]
    )
return "You Must Specify a path \"--path=\" " unless opt[:path]

@genres = Genre.all
@artists = Artist.all
@albums = Album.all
@songs = Song.all
@types = Songtype.all

DEFAULTS = {:volume => 0.7, :fade_duration => -1, :fade_in => true}

### Important models, all have Timestamps plus whatever is below.
#=> Artist (id: integer, name: string)
#=> Genre  (id: integer, name: string)
#=> Album  (id: integer, name: string, artist_id: integer, genre_id: integer)
#=> Song   (id: integer, name: string, track: integer, year: integer, album_id: integer, artist_id: integer,
#        genre_id: integer, comments: text, size: integer, pre_id: integer, post_id: integer, fade_duration: float,
#        volume: float, fade_in: boolean, user_id: integer, archive_number: integer, file: text)
###

  Find.find(opt[:path]) do |path|
      if FileTest.file?(path) && !path.match(".AppleDouble")
        kind = path.split(".")
        case kind.last.downcase
            when "mp3"
              tag = ID3Lib::Tag.new(path)
              
                ##Build a song object, while working with the rest
                attributes = DEFAULTS
                attributes[:file] = Iconv.conv('UTF-8', 'LATIN1', path)
                ## Shortcircuit if its already present
                if !@songs.find{|s| s.file == attributes[:file]}
                    attributes[:title] = !!tag.title ? Iconv.conv('UTF-8', 'LATIN1', tag.title) : "<no title>"
                    attributes[:size] = File.size(path)
                    attributes[:year] = tag.year
                    attributes[:track] = tag.track ? tag.track.split("/").first.to_i : nil
                    attributes[:songtype] = @types.find{|t| t.identifier == kind.last.downcase}
                
                    ## Try to find old archive _id
                    tag_text = tag.find{|t| t[:id]==:TXXX}
                    attributes[:archive_number] = tag_text[:text] if tag_text
                    
                    #### Try to find each of the rest of the important fields
                    ##Artist
                    artist_tag = tag.artist ? Iconv.conv('UTF-8', 'LATIN1', tag.artist) : "<no artist>"
                    artist = @artists.find{|a| a.name == artist_tag} || Artist.new({:name=>artist_tag})
                    if artist.new_record?
                        artist.save
                        @artists.unshift(artist)
                    end
                    attributes[:artist] = artist
                    
                    ##Genre
                    genre_tag  =  tag.genre ? Iconv.conv('UTF-8', 'LATIN1', tag.genre) : "Unclassifiable"
                    if genre_tag.match(/^\(\d+\)$/)
                        num = genre_tag.gsub("(","").gsub(")","").to_i
                        genre_tag = Tagger::GENRES[num]
                    end
                    genre = @genres.find{|g| g.name == genre_tag} || Genre.new({:name=>genre_tag})
                    if genre.new_record?
                        genre.save
                        @genres.unshift(genre)
                    end
                    attributes[:genre] = genre
                    
                    ##Album
                    album_tag  =  tag.album ? Iconv.conv('UTF-8', 'LATIN1', tag.album) : "<no album>"
                    album = @albums.find{|a| a.name == album_tag} || Album.new({:name=>album_tag, :genre=> genre})
                    if album.new_record?
                        album.save
                        @albums.unshift(album)
                    end
                    attributes[:album] = album
                    
                    song = Song.new(attributes)
                    if song.save
                        puts "Saved MP3 Titled #{attributes[:title]}"
                        @songs.unshift(song)
                    else
                        puts "Failed to save MP3 Titled #{attributes[:title]}"
                    end
                else
                    puts "Song in DB #{attributes[:title]}"
                end
 
            when "m4a", "m4p"
              tag = MP4Info.open(path)
              ##Build a song object, while working with the rest
              attributes = DEFAULTS
              attributes[:file] = Iconv.conv('UTF-8', 'LATIN1', path)
              if !@songs.find{|s| s.file == attributes[:file]}
                attributes[:title] = !!tag.NAM ? Iconv.conv('UTF-8', 'LATIN1', tag.NAM) : "<no title>"
                attributes[:size] = File.size(path)
                attributes[:year] = tag.DAY.to_i
                attributes[:track] = tag.TRKN ? tag.TRKN.first : nil
		attributes[:songtype] = @types.find{|t| t.identifier == kind.last.downcase}

                #### Try to find each of the rest of the important fields
                ##Artist
                artist_tag = tag.ART ? Iconv.conv('UTF-8', 'LATIN1', tag.ART) : "<no artist>"
                artist = @artists.find{|a| a.name == artist_tag} || Artist.new({:name=>artist_tag})
                if artist.new_record?
                    artist.save
                    @artists.unshift(artist)
                end
                attributes[:artist] = artist
                
                ##Genre
                genre_tag  =  tag.GNRE ? Iconv.conv('UTF-8', 'LATIN1', tag.GNRE) : "Unclassifiable"
                genre = @genres.find{|g| g.name == genre_tag} || Genre.new({:name=>genre_tag})
                if genre.new_record?
                    genre.save
                    @genres.unshift(genre)
                end
                attributes[:genre] = genre
                
                ##Album
                album_tag  =  tag.ALB ? Iconv.conv('UTF-8', 'LATIN1', tag.ALB) : "<no album>"
                album = @albums.find{|a| a.name == album_tag} || Album.new({:name=>album_tag, :genre=> genre})
                if album.new_record?
                    album.save
                    @albums.unshift(album)
                end
                attributes[:album] = album
                
                song = Song.new(attributes)
                if song.save
                    puts "Saved MP3 Titled #{attributes[:title]}"
                    @songs.unshift(song)
                else
                    puts "Failed to save MP3 Titled #{attributes[:title]}"
                end
              else
                puts "Song in DB #{attributes[:title]}"
              end
        else
            puts "unknown"
            #puts "#{path} is some other shit!!"
        end
      else
        puts "."
    end
  end
    
 
