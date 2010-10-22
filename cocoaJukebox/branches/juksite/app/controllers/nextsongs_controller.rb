class NextsongsController < ApplicationController
  def index
    if Randlist.count < 10
      Randlist.padRands
    end
    
    item = Reqlist.first :order => :sort
    item ||= Randlist.first :order => :sort
    
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
      when "skipsong"
        system "#{app} skipsong"
      else
        
      end
    end
    respond_to do |format|
      format.js
    end
  end
  
  
end
