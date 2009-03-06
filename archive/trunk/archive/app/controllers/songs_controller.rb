class SongsController < ApplicationController
  def index
    @songs = Song.search params[:search], :include => [:songtype, :album, :artist, :genre], 
    :order => order_with_default("title", "asc") , :page=> params[:page], :per_page => 100
  end

  def send_one_song
   song = Song.find params[:id]
   send_file song.file, :type => song.songtype.mime_type
  end
  
  def stream_one_song
   song = Song.find params[:id]
   #send_data(@media.data, :type => "audio/mpeg", :filename => "media-#{@media.id}.mp3", :disposition => "inline")
   respond_to do |format|
    format.mp3 {send_file song.file}
    end
  end


  # GET /songs/1
  # GET /songs/1.xml
  def show
    @song = Song.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.mp3 do
        render :action => :show, :layout=>false
        send_file @song.file, :type => "", :disposition => :inline, :stream => :true
    end
      format.xml  { render :xml => @song }
    end
  end

  # GET /songs/new
  # GET /songs/new.xml
  def new
    @song = Song.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @song }
    end
  end

  # GET /songs/1/edit
  def edit
    @song = Song.find(params[:id])
  end

  # POST /songs
  # POST /songs.xml
  def create
    @song = Song.new(params[:song])

    respond_to do |format|
      if @song.save
        flash[:notice] = 'Song was successfully created.'
        format.html { redirect_to(@song) }
        format.xml  { render :xml => @song, :status => :created, :location => @song }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @song.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /songs/1
  # PUT /songs/1.xml
  def update
    @song = Song.find(params[:id])

    respond_to do |format|
      if @song.update_attributes(params[:song])
        flash[:notice] = 'Song was successfully updated.'
        format.html { redirect_to(@song) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @song.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.xml
  def destroy
    @song = Song.find(params[:id])
    @song.destroy

    respond_to do |format|
      format.html { redirect_to(songs_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  def order_with_default(column, direction)
    if params[:sort]
      "#{params[:sort]} #{params[:direction]}"
    else
      "#{column} #{direction}"
    end
  end
  
end
