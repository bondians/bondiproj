class SelectionsDispatchController < ApplicationController
  def dispatch
    ## i need these, make sure you pull yours out safely
    songs = params[:songs]
    playlist = Playlist.find(params[:playlist][:id]) if params[:playlist]
    playlist ||= Playlist.first
    
    case params[:submit]
    when "Add to Playlist"
      Playlist.add_songs_to_playlist(songs, playlist)
      redirect_to(playlist)

    when "Tar"
      
      files = songs.collect {|s| Song.find(s).file.gsub(/^[\/]/,"")}
      data = IO.popen("cd / ; /bin/tar cvhfs - \"#{files.join "\" \""}\"" )
      send_data( data, :filename => 'songs.tar', :type => :tar)
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
