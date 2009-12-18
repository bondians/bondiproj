class JukeboxInternalController < ApplicationController
  def next_song
    @song = Jukebox.next!
  end
  
  def stopped_playing
    Jukebox.playing = nil
  end
end
