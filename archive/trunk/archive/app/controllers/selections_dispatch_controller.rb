class SelectionsDispatchController < ApplicationController
  def dispatch
    ## i need these, make sure you pull yours out safely
    songs = params[:songs]
    playlist = Playlist.find(params[:playlist][:id]) if params[:playlist]

    case params[:submit]
    when "Add to Playlist"
      Playlist.add_songs_to_playlist(songs, playlist)
      redirect_to(playlist)

    when "Remove from Playlist"
      Playlist.remove_songs_from_playlist(songs, playlist)
      redirect_to(playlist)
    end
  end
end
