class SongsController < ApplicationController
  
  def index
    params[:page] ||= 1
    if params[:search]
      @songs = Song.search (params[:search], params[:page])
    
      respond_to do |format|
        format.html
        format.xml { render :xml => @songs }
      end
    else
      @songs = Song.paginate :page => params[:page], :order => 'created_at DESC'
    end

  end

  # GET /songs/1
  # GET /songs/1.xml
  def show
    @song = Song.find(params[:id])
    @tags = Tagger.new @song.file
    @songs = params[:songs]
    
    respond_to do |format|
      format.html
      format.m3u
      format.xml { render :xml => @song }
      
      format.m4a { send_song_file @song}
      format.mp3 { send_song_file @song}
      format.m4p { send_song_file @song}
      # make sure songtype.identifier is not the name of a "real" method!
#      unless format.respond_to? @song.songtype.identifier
#        format.send(@song.songtype.identifier) { send_song_file @song }
#      end
      
      format.jpg {send_song_cover @tags} if @tags.cover
      format.png {send_song_cover @tags} if @tags.cover
      format.tar {send_song_tar @songs}

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
        flash[:note] = 'Song was successfully created.'
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
        flash[:note] = 'Song was successfully updated.'
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
  
  def send_song_file(song)
    send_file song.file, :type => song.songtype.mime_type, :disposition => "inline", :x_send_file => true
  end
  
  def send_song_cover(tags)
    if tags.cover
      send_data tags.cover, :type => tags.covertype, :disposition => "inline"
    end
  end
  
  def send_song_tar(songs)
      files = songs.collect {|s| Song.find(s).file.gsub(/^[\/]/,"")}
      data = IO.popen("cd / ; /bin/tar cvhfs - \"#{files.join "\" \""}\"" ).readlines
      Process.wait
      send_data( data, :filename => 'songs.tar', :type => :tar)
  end
  
  def order_with_default(column, direction)
    if params[:sort]
      "#{params[:sort]} #{params[:direction]}"
    else
      "#{column} #{direction}"
    end
  end
  
end
