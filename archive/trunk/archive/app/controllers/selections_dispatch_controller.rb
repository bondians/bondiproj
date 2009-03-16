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
      debugger
      1
      1
      Playlist.remove_songs_from_playlist(songs, playlist)
      redirect_to(playlist)
    end
  end
end
