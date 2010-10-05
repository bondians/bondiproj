class SelectionsController < ApplicationController
  def index
    randlist = Randlist.all :order => :sort
    @randsongs = randlist.map{|a| a.song}
    reqlist = Reqlist.all :order => :sort
    @reqsongs = reqlist.map{|p| p.song.form_idx = p.id; p.song}
    
    respond_to do |format|
      format.html #index.html.erb
      format.js   #index.js.rjs
    end
    
  end
  
end
