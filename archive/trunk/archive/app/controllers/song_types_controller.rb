class SongTypesController < ApplicationController
  # GET /song_types
  # GET /song_types.xml
  def index
    @song_types = SongType.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @song_types }
    end
  end

  # GET /song_types/1
  # GET /song_types/1.xml
  def show
    @song_type = SongType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @song_type }
    end
  end

  # GET /song_types/new
  # GET /song_types/new.xml
  def new
    @song_type = SongType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @song_type }
    end
  end

  # GET /song_types/1/edit
  def edit
    @song_type = SongType.find(params[:id])
  end

  # POST /song_types
  # POST /song_types.xml
  def create
    @song_type = SongType.new(params[:song_type])

    respond_to do |format|
      if @song_type.save
        flash[:notice] = 'SongType was successfully created.'
        format.html { redirect_to(@song_type) }
        format.xml  { render :xml => @song_type, :status => :created, :location => @song_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @song_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /song_types/1
  # PUT /song_types/1.xml
  def update
    @song_type = SongType.find(params[:id])

    respond_to do |format|
      if @song_type.update_attributes(params[:song_type])
        flash[:notice] = 'SongType was successfully updated.'
        format.html { redirect_to(@song_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @song_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /song_types/1
  # DELETE /song_types/1.xml
  def destroy
    @song_type = SongType.find(params[:id])
    @song_type.destroy

    respond_to do |format|
      format.html { redirect_to(song_types_url) }
      format.xml  { head :ok }
    end
  end
end
