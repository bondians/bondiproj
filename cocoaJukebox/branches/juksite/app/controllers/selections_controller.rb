class SelectionsController < ApplicationController
  def index
    randlist = Randlist.all :order => :sort
    @randsongs = randlist.map{|a| a.song}
    @reqlist = Reqlist.all :order => :sort
  end
end
