#!/usr/bin/env ruby

require File.expand_path(__FILE__ + "/../../config/environment")
require "#{RAILS_ROOT}/lib/tagger"

require 'find'
require 'id3lib'
require 'mp4info'
require 'ruby-debug'

@genres = Genre.all
@artists = Artist.all
@albums = Album.all

@types = Songtype.all
@songs = Song.search nil, :include => [:songtype, :album, :artist, :genre], 
    :order => 'title desc' , :page=> 1, :per_page => 100

DEFAULTS = {:volume => 0.7, :fade_duration => -1, :fade_in => true}

### Important models, all have Timestamps plus whatever is below.
#=> Artist (id: integer, name: string)
#=> Genre  (id: integer, name: string)
#=> Album  (id: integer, name: string, artist_id: integer, genre_id: integer)
#=> Song   (id: integer, name: string, track: integer, year: integer, album_id: integer, artist_id: integer,
#        genre_id: integer, comments: text, size: integer, pre_id: integer, post_id: integer, fade_duration: float,
#        volume: float, fade_in: boolean, user_id: integer, archive_number: integer, file: text)
###

@songs.each do |path|
    kind = path.songtype.identifier
    case kind
    when "mp3"
      tag = ID3Lib::Tag.new(path.file)
      
        ##Build a song object, while working with the rest
        attributes = DEFAULTS
        ## Shortcircuit if its already present
            attributes[:title] = !!tag.title ? Iconv.conv('UTF-8', 'LATIN1', tag.title) : "<no ttle>"
            attributes[:title] = Iconv.conv('UTF-8', 'UTF-16', tag.title) unless attributes[:title].match(/[a-zA-Z][a-zA-Z]/)
            
            #### Try to find each of the rest of the important fields
            ##Artist
            artist_tag = tag.artist ? Iconv.conv('UTF-8', 'LATIN1', tag.artist) : "<no artist>"
            artist_tag = Iconv.conv('UTF-8', 'UTF-16', tag.artist) unless artist_tag.match(/[a-zA-Z][a-zA-Z]/)
            artist = @artists.find{|a| a.name == artist_tag} || Artist.new({:name=>artist_tag})
            if artist.new_record?
                artist.save
                @artists.unshift(artist)
            end
            attributes[:artist] = artist
            
            ##Genre
            genre_tag  =  tag.genre ? Iconv.conv('UTF-8', 'UTF-16', tag.genre) : "Unclassifiable"
            genre_tag  =  Iconv.conv('UTF-8', 'LATIN1', tag.genre) unless genre_tag.match(/[a-zA-Z][a-z][A-Z]/)
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
            album_tag  =  Iconv.conv('UTF-8', 'UTF-16', tag.album) unless album_tag.match(/[a-zA-Z][a-zA-Z]/)
            album = @albums.find{|a| a.name == album_tag} || Album.new({:name=>album_tag, :genre=> genre})
            if album.new_record?
                album.save
                @albums.unshift(album)
            end
            attributes[:album] = album
            
            path.update_attributes(attributes)
            if path.save
                puts "Saved MP3 Titled #{attributes[:title]}"
                @songs.unshift(path)
            else
                puts "Failed to save MP3 Titled #{attributes[:title]}"
            end

    when "m4a", "m4p"
        puts "m4p/m4a"
    else
        puts "unknown reason"
    end
end    
 
