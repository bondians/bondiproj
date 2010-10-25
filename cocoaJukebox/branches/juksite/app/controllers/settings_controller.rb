class SettingsController < ApplicationController
  
  def index
    @playlists = Playlist.all :include => [:user, :plentries]
    @playlists.sort! {|x,y| x.user.name <=> y.user.name}
    vol = `defaults read com.deepbondi.cocoaJukebox kMasterVolume`
    vol = 1.0 if (vol.empty?)
    @currentVolume = vol.to_f
  end
  
  def update
    vol = `defaults read com.deepbondi.cocoaJukebox kMasterVolume`
    vol = 1.0 if (vol.empty?)
    currentVolume = vol.to_f
    newVolume = params[:newVolume].to_f
    unless (currentVolume == newVolume)
      app = "#{RAILS_ROOT}/script/jookieControl -volume"
      system "#{app} #{newVolume}"
    end
    if (params[:setting] && params[:setting][:hidem4p])
      Setting.hide_protected= true
    else
      Setting.hide_protected= false
    end
    
    if params[:playlist] && params[:playlist]["playlist_ids"]
      active =  params[:playlist]["playlist_ids"].collect{|a| a.to_i}
    else
      active = []
    end
    
    playlists = Playlist.all
    playlists.each do |list|
      active.include?(list.id) ? list.active = true : list.active = false
      list.save
    end
    redirect_to(selections_url)
  end
end
