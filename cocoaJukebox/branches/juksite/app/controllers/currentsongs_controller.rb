class CurrentsongsController < ApplicationController
    def index
    params[:page] ||= 1
    playentries = Currentsong.paginate :page => params[:page], :order => 'id DESC'
    @songs = playentries.select{|s| s.song}
  end
end
