class SelectionsDispatchController < ApplicationController
  def dispatch
    ## i need these, make sure you pull yours out safely
    songs = params[:songs]
    playlist = Playlist.find(params[:playlist][:id]) if params[:playlist]
    
    case params[:submit]
    when "Add to Playlist"
      Playlist.add_songs_to_playlist(songs, playlist)
      redirect_to(playlist)

    when "Tar"
      files = songs.each {|s| print '#{s.file}'}
      send_data( system( "/bin/tar cvhfs - #{files}" ), :filename => 'songs.tar', :type => :tar)
      redirect_to(playlist)
      
    when "Remove from Playlist"
      Playlist.remove_songs_from_playlist(songs, playlist)
      redirect_to(playlist)
      
    when "Get Streaming List"
      @songs = Song.find songs, :include => :songtype
      respond_to do |format|
        format.m3u {render :template => '/playlists/show'}
      end
    
    when "Set Order"
      new_index = params[:index]
      playlist = Playlist.set_index(new_index)
      redirect_to(playlist)
      
    end
  end
end
