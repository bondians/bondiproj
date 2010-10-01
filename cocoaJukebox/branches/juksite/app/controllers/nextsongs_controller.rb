class NextsongsController < ApplicationController
  def index
    rands = Randlist.all :order => :sort
    if rands.length < 10
      Song.padRands
      rands = Randlist.all :order => :sort
    end
    @next = Reqlist.first :order => :sort
    if @next
      @next.destroy
    else
      @next = rands.first
      @next.destroy
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @song }
      format.txt
    end
  end
end
