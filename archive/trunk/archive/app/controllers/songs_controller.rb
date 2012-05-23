class SongsController < ApplicationController
  skip_before_filter :goldberg_security_up
  prepend_before_filter :do_basic_auth, :goldberg_security_up

  def index
    if params[:search]
      @songs = Song.search params[:search], :include => [:songtype, :album, :artist, :genre, :plentries],
      :order => order_with_default("title", "asc") , :page => params[:page], :per_page => 100
      logger.debug "stuff"
      logger.debug @songs


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
      ## Too Smart by 1/2 this method get's cached as available and then this bypasses
      ## Results in a weird HTML "unpossible" error
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
    unless @song.songtype.name == "mp3"
      flash[:error] = "It doesn't work on that song type"
      redirect_to(songs_url)
    end
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
    unless @song.songtype.name == "mp3"
      flash[:error] = "It doesn't work on that song type"
      redirect_to(songs_url)
    end
    if (@song && tag = (Tagger.new(@song.file)) )
      ## Title
      title_tag = params[:title]
      if title_tag
        tag.title= title_tag
        params[:song][:title] = title_tag
      end
      ## Artist
      artist_tag = params[:artist]
      if artist_tag
        artist = (Artist.find_by_name artist_tag) || Artist.new({:name=>artist_tag})
          if artist.new_record?
            artist.save
          end
        params[:song][:artist] = artist
        tag.artist= artist_tag
      end
      ## Genre
      genre_tag  =  params[:genre]
      if genre_tag
        genre = (Genre.find_by_name genre_tag) || Genre.new({:name=>genre_tag})
        if genre.new_record?
          genre.save
        end
        params[:song][:genre] = genre
        tag.genre= genre_tag
      end
      genre ||= tag.lookup_genre
      genre_tag ||= genre.name
      ## Album

      album_tag  =  params[:album]
      if album_tag
        album = (Album.find_by_name album_tag) || Album.new({:name=>album_tag})
        if album.new_record?
          album = Album.new({:name=>album_tag, :genre=> genre})
          album.save
          album.artists.push artist
        else
          unless album.artists.include? artist
            album.artists.push artist
          end
        end
        params[:song][:album] = album
        tag.album= album_tag
      end
      tag.saveChanges
      b = Tagger.new(@song.file)
      unless ( ( params[:title] && b.title == params[:title]) && ( params[:artist] && b.artist == params[:artist]) && (params[:album] && b.album == params[:album]) && (params[:genre] && b.lookup_genre == params[:genre]) )
        flash[:error] = "Song file did not save"
        redirect_to edit_song_path(@song)
      end
      params[:song][:filemod] = Time.now
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
    else
      flash[:error] = "Song or its file Was not found"
      redirect_to(songs_url)
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.xml
  def destroy
    @song = Song.find(params[:id])
    cull = Cull.new :attributes => {:file => @song.file}
    if cull.save
      @song.destroy
      respond_to do |format|
        format.html { redirect_to(songs_url) }
        format.xml  { head :ok }
      end
    else
      flash[:error] = "couldn't save cull data"
      redirect_to(@song)
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
    raise "you should not be here"
      files = songs.collect {|s| Song.find(s).file.gsub(/^[\/]/,"")}
      send_data(IO.popen("cd / ; /bin/tar cvhfs - \"#{files.join "\" \""}\"" ).readlines)
      Process.wait
      #send_data( data, :filename => 'songs.tar', :type => :tar)
  end

  def order_with_default(column, direction)
    if params[:sort]
      "#{params[:sort]} #{params[:direction]}"
    else
      "#{column} #{direction}"
    end
  end

end
