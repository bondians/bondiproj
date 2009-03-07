class SongviewsController < ApplicationController
  
  def stream_one_song
    song = Song.find params[:id]
    send_file song.file, :type => song.songtype.mime_type, :disposition => "inline"
  end
end
