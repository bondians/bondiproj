class PlaylistsController < ApplicationController
  # GET /playlists
  # GET /playlists.xml
  def index
    @other_playlists = Playlist.all :include=> :user

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @playlists }
    end
  end

  # GET /playlists/1
  # GET /playlists/1.xml
  def show
    @playlist = Playlist.find(params[:id], :include => :songs)
    plentries = @playlist.plentries.sort
    @songs = plentries.map{|p| p.song.form_idx = p.id; p.song}

    respond_to do |format|
      format.html # show.html.erb
      format.m3u
      format.xml  { render :xml => @playlist }
    end
  end

  # GET /playlists/new
  # GET /playlists/new.xml
  def new
    @playlist = Playlist.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @playlist }
    end
  end

  # GET /playlists/1/edit
  def edit
    @playlist = Playlist.find(params[:id], :include=>[:user, :songs])
  end

  # POST /playlists
  # POST /playlists.xml
  def create
    
    @playlist = Playlist.new(params[:playlist])
    @playlist.user = User.find_by_name "deepbondi"
    
    respond_to do |format|
      if @playlist.save
        flash[:note] = 'Playlist was successfully created.'
        format.html { redirect_to(playlists_url) }
        format.xml  { render :xml => @playlist, :status => :created, :location => @playlist }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @playlist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /playlists/1
  # PUT /playlists/1.xml
  def update
    
    @playlist = Playlist.find(params[:id])

    respond_to do |format|
      if @playlist.update_attributes(params[:playlist])
        flash[:note] = 'Playlist was successfully updated.'
        format.html { redirect_to(@playlist) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @playlist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /playlists/1
  # DELETE /playlists/1.xml
  def destroy
    @playlist = Playlist.find(params[:id])
    @playlist.destroy

    respond_to do |format|
      format.html { redirect_to(playlists_url) }
      format.xml  { head :ok }
    end
  end
end
