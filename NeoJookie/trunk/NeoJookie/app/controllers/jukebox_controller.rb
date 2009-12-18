class JukeboxController < ApplicationController
  def initialize
    @jukebox_name = "Musical Mike's Jazz Corner"
    @per_page = 20
  end
  
  def index
    _get_pagination_params
    
    @page_title = "Now Playing"
    
    @playing = Jukebox.playing
    @playingList = Jukebox.playingList
    @requests = Jukebox.requestList
    
    Jukebox.fillRandom!(@per_page - @requests.count)
    @random = Jukebox.randomList
  end
  
  def browse_artist
    _browse_by(:artist_id => params[:id])
  end
  
  def browse_album
    _browse_by(:album_id => params[:id])
  end
  
  def browse_genre
    _browse_by(:genre_id => params[:id])
  end
  
  def search
    @query = params[:q] || ""
    
    if @query.blank?
      @page_title = "Search Results"
    else
      @page_title = "Search Results for \"" + @query + "\""
    end
    
    _get_pagination_params
    
    @results = Song.find_by_contents(@query, :per_page => @per_page, :offset => @offset)
    _pagination(@results.total_hits)
  end
  
  def request_song
    @requested = params[:id].to_i
    
    if (@requested > 0)
      @requested = Jukebox.request_id!(@requested)
    end
    
    redirect_to :action => :index
  end
  
  private
  
  def _browse_by(conditions)
    _get_pagination_params
    
    @songs = Song.find(:all, :conditions => conditions, :limit => @per_page, :offset => @offset)
    _pagination(Song.count(:conditions => conditions))
  end
  
  def _get_pagination_params
    @offset = params[:o].to_i || 0
    
    c = params[:c].to_i
    if c > 0 
      @per_page = c
    end
  end
  
  def _pagination(total)
    @total_hits = total.to_i
    
    @current_page = (@offset / @per_page).to_i + 1
    @total_pages = (@total_hits / @per_page).to_i + 1
    
    if @current_page <= 1
      @first_page = true
    end
    
    if @current_page >= @total_pages
      @last_page = true
    end
  end
end
