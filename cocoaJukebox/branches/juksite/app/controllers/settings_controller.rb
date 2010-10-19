class SettingsController < ApplicationController
  
  def index
    @playlists = Playlist.all :include => [:user, :plentries]
    @playlists.sort! {|x,y| x.user.name <=> y.user.name}
    
  end
  
  def update
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
