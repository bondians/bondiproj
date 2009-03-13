class SelectionsDispatchController < ApplicationController
  def dispatch
    ## i need these, make sure you pull yours out safely
    songs = params[:songs]
    playlist = params[:playlist][:id] if params[:playlist]
    
    case params[:submit]
    when "Add to Playlist"
      Playlist.add_songs_to_playlist(songs, playlist)
      redirect_to playlist(playlist)
    end
  end
end
