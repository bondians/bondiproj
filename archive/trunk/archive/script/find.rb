#!/usr/bin/env ruby

require 'find'
require 'id3lib'
require 'mp4info'
require 'ruby-debug'
require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'pp'
require 'optparse'

totalNumberOfSongs = 0
DEFAULT_PATH = "/Volumes/MajorTuneage/"
##########################  Parse Options and all that crap
options = OpenStruct.new

OptionParser.new do |opts|
    opts.banner = "Usage: find.rb [options]"
    options.path = DEFAULT_PATH
    options.full = false
    #options.dev  = false

    # Mandatory argument.
    opts.on("-p", "--path \"<path>\"",
            "Specify the path to start searching") do |pth|
      options.path = pth
    end

    # Boolean switch.
    opts.on("-f", "--[no-]full", "Ignore Dates") do |f|
      options.full = f
    end
    
    #environment
    opts.on("-d", "--dev", "Development Environment") do |d|
        options.dev = d
    end
    
end.parse!

RAILS_ENV = (options.dev ? "development" : "production")

require File.expand_path(__FILE__ + "/../../config/environment")
require "#{RAILS_ROOT}/lib/tagger"





@genres = Genre.all
@artists = Artist.all
@albums = Album.all
@songs = Song.all
@types = Songtype.all

@lastrun = Finder.lastrun

puts "\n\nWas last run #{@lastrun.started} and #{@lastrun.added} songs were processed\n\n"
@currun = Finder.fresh

DEFAULTS = {:volume => 0.7, :fade_duration => -1, :fade_in => true}

### Important models, all have Timestamps plus whatever is below.
#=> Artist (id: integer, name: string)
#=> Genre  (id: integer, name: string)
#=> Album  (id: integer, name: string, artist_id: integer, genre_id: integer)
#=> Song   (id: integer, name: string, track: integer, year: integer, album_id: integer, artist_id: integer,
#        genre_id: integer, comments: text, size: integer, pre_id: integer, post_id: integer, fade_duration: float,
#        volume: float, fade_in: boolean, user_id: integer, archive_number: integer, file: text)
###

Find.find(options.path) do |path|
    begin
        ########### This currently sucks, becaus i eventually want to modify files.. however, this is no problem
        ########### Currently as that is not implemented it <should> be fixd when file modding becomes possible
        if (options.full || (@lastrun.started < File.ctime(path)))
            if FileTest.file?(path) && Tagger.valid?(path)
                ##Build a song object, while working with the rest
                attributes = DEFAULTS
                attributes[:file] = Iconv.conv('UTF-8', 'LATIN1', path)
                ## Shortcircuit if its already present
                wassong = @songs.find{|s| s.file == attributes[:file]}
                unless !!wassong
                    tag = Tagger.new(path)
                    attributes[:title] = tag.title
                    attributes[:size] = tag.size
                    attributes[:year] = tag.year
                    attributes[:track] = tag.track || 0
                    attributes[:songtype] = @types.find{|t| t.identifier == tag.filetype}
            
                    ## Try to find old archive _id
                    ##### Relegated to legacy
		    legacy_num = tag.legacy_num
                    attributes[:archive_number] = legacy_num if legacy_num
                    
                    #### Try to find each of the rest of the important fields
                    ##Artist
                    artist_tag = tag.artist
                    artist = @artists.find{|a| a.name == artist_tag} || Artist.new({:name=>artist_tag})
                    if artist.new_record?
                        artist.save
                        @artists.unshift(artist)
                    end
                    attributes[:artist] = artist
                
                    ##Genre
                    genre_tag  =  tag.lookup_genre
                    genre = @genres.find{|g| g.name == genre_tag} || Genre.new({:name=>genre_tag})
                    if genre.new_record?
                        genre.save
                        @genres.unshift(genre)
                    end
                    attributes[:genre] = genre
                
                    ##Album
                    album_tag  =  tag.album
                    album = @albums.find{|a| a.name == album_tag} || Album.new({:name=>album_tag})
                    if album.new_record?
                        album = Album.new({:name=>album_tag, :genre=> genre})
                        album.save
                        album.artists.push artist
                        @albums.unshift(album)
                    else
                        unless album.artists.include? artist
                            album.artists.push artist
                        end
                    end
                    attributes[:album] = album
                
                    song = Song.new(attributes)
                    if song.save
                        puts "Saved #{(totalNumberOfSongs += 1).to_s} #{tag.filetype.upcase} Titled #{attributes[:title]}"
                        @songs.unshift(song)
                        @currun.added += 1
                        @currun.save
                    else
                        puts "Failed to save #{tag.filetype.upcase} Titled #{attributes[:title]}"
                    end
                end
        
            else
                print "."
            end
        end
    rescue Exception => e
        puts "choked on #{path}"
        puts e.message
        puts e.backtrace.inspect
    end
end
    
    @currun.completed = Time.now
    @currun.success = true if options.path == DEFAULT_PATH
    @currun.save
    
    system "rake thinking_sphinx:index RAILS_ENV=\"#{RAILS_ENV}\""
    system "rake thinking_sphinx:stop RAILS_ENV=\"#{RAILS_ENV}\""
    system "rake thinking_sphinx:start RAILS_ENV=\"#{RAILS_ENV}\""
    
