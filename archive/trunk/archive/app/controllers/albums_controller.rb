class AlbumsController < ApplicationController
  # GET /albums
  # GET /albums.xml
  def index
    #@albums = Album.find(:all, :include=>:genre)
    @albums = Album.search params[:search], :order => :name, :include => [:artist, :genre, :songs], :page=> params[:page], :per_page => 10
  end

  # GET /albums/1
  # GET /albums/1.xml
  def show
    @album = Album.find(params[:id], :include => [:artist, :genre, :songs])
  end

  # GET /albums/new
  # GET /albums/new.xml
  def new
    @album = Album.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @album }
    end
  end

  # GET /albums/1/edit
  def edit
    @album = Album.find(params[:id])
  end

  # POST /albums
  # POST /albums.xml
  def create
    @album = Album.new(params[:album])

    respond_to do |format|
      if @album.save
        flash[:note] = 'Album was successfully created.'
        format.html { redirect_to(@album) }
        format.xml  { render :xml => @album, :status => :created, :location => @album }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @album.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /albums/1
  # PUT /albums/1.xml
  def update
    
    debugger
    1
    1
    
    @album = Album.find(params[:id])

    respond_to do |format|
      if @album.update_attributes(params[:album])
        flash[:note] = 'Album was successfully updated.'
        format.html { redirect_to(@album) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @album.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.xml
  def destroy
    @album = Album.find(params[:id])
    @album.destroy

    respond_to do |format|
      format.html { redirect_to(albums_url) }
      format.xml  { head :ok }
    end
  end
end
