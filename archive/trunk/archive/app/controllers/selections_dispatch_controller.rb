class SelectionsDispatchController < ApplicationController
  def dispatch
    ## i need these, make sure you pull yours out safely
    songs = params[:songs]
    playlist = Playlist.find(params[:playlist][:id]) if params[:playlist]
    debugger
    1
    1
    
    case params[:submit]
    when "Add to Playlist"
      Playlist.add_songs_to_playlist(songs, playlist)
      redirect_to(playlist)

    when "Remove from Playlist"
      Playlist.remove_songs_from_playlist(songs, playlist)
      redirect_to(playlist)
      
    when "Get Streaming List"
      @songs = Song.find songs, :include => :songtype
      respond_to do |format|
        format.m3u {render :template => '/playlists/show'}
      end
      
      
    end
  end
end
