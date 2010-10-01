class SelectionsController < ApplicationController
  def index
    randlist = Randlist.all :order => :sort
    @randsongs = randlist.map{|a| a.song}
    reqlist = Reqlist.all :order => :sort
    @reqsongs = reqlist.map{|p| p.song.form_idx = p.id; p.song}

  end
end
