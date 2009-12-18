require "ums_itunes"
require "plist"

module JukeboxHelper
  def self.itunes_xml_import(xml)
    if (File.file? xml)
      return nil
    end
    
    deepbondi = User.find_by_name "deepbondi"
    
    songs = {}
    lists = []
    
    plist = Plist::parse_xml xml
    playlists = UmsItunes::Playlist.create_from_plist plist
    
    playlists.each do |playlist|
      list = Playlist.find_or_create_by_name_and_user_id(playlist.name, deepbondi)
      
      playlist.tracks.each do |track|
        song = Song.find_or_create_by_file_path(track.location)
        
        song.name = track.name
        song.track = track.track_number
        
        song.artist = Artist.find_or_create_by_name(track.artist) || "--"
        song.genre = Genre.find_or_create_by_name(track.data["Genre"]) || "--"
        song.album = Album.find_or_create_by_name_and_artist_id_and_genre_id(
          track.album, song.artist.id, song.genre.id) || "--"
        
        song.save
        
        unless list.songs.include? song
          list.songs << song
        end
      end
      
      lists << list
      list.save
    end
    
    return lists
  end
end
