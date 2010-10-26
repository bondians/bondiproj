class NextsongsController < ApplicationController
  def index
    item = nil
    if Randlist.count < 10
      Randlist.padRands
    end
    if Setting.hide_protected?
      until (item && item.song.songtype_id != 2)
        item.destroy if item
        if Randlist.count < 10
          Randlist.padRands
        end
        item = Reqlist.first :order => :sort
        item ||= Randlist.first :order => :sort
      end
    else
      item = Reqlist.first :order => :sort
      item ||= Randlist.first :order => :sort
    end
      
    
    if item
      @song = item.song
      item.destroy
    end
    
    @song ||= Song.first ## give up something NMW
    Currentsong.setPlaying(@song)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @song }
      format.txt
    end
  end
  
  def action
    app = "#{RAILS_ROOT}/script/jookieControl -action"
    what = params[:do]
    if what
      case what
      when "playerSkip"
        system "#{app} skipsong"
      when "playerStartStop"
        system "#{app} startstop"
      when "playerPause"
        system "#{app} pause"
      else
        
      end
    end
    respond_to do |format|
      format.js
    end
  end
  
  
end
