class NextsongsController < ApplicationController
  def index
    rands = Randlist.all :order => :sort
    if rands.length < 10
      Song.padRands
      rands = Randlist.all :order => :sort
    end
    item = Reqlist.first :order => :sort
    if item
      @song = item.song
      item.destroy
    else
      item = rands.first
      if item
        @song = item.song
        item.destroy
      end
    end
    @song ||= Song.first ## give up something NMW
    Currentsong.setPlaying(@song)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @song }
      format.txt
    end
  end
end
