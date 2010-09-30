class SongtypesController < ApplicationController
  # GET /songtypes
  # GET /songtypes.xml
  def index
    @songtypes = Songtype.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @songtypes }
    end
  end

  # GET /songtypes/1
  # GET /songtypes/1.xml
  def show
    @songtype = Songtype.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @songtype }
    end
  end

  # GET /songtypes/new
  # GET /songtypes/new.xml
  def new
    @songtype = Songtype.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @songtype }
    end
  end

  # GET /songtypes/1/edit
  def edit
    @songtype = Songtype.find(params[:id])
  end

  # POST /songtypes
  # POST /songtypes.xml
  def create
    @songtype = Songtype.new(params[:songtype])

    respond_to do |format|
      if @songtype.save
        flash[:note] = 'Songtype was successfully created.'
        format.html { redirect_to(@songtype) }
        format.xml  { render :xml => @songtype, :status => :created, :location => @songtype }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @songtype.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /songtypes/1
  # PUT /songtypes/1.xml
  def update
    @songtype = Songtype.find(params[:id])

    respond_to do |format|
      if @songtype.update_attributes(params[:songtype])
        flash[:note] = 'Songtype was successfully updated.'
        format.html { redirect_to(@songtype) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @songtype.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /songtypes/1
  # DELETE /songtypes/1.xml
  def destroy
    @songtype = Songtype.find(params[:id])
    @songtype.destroy

    respond_to do |format|
      format.html { redirect_to(songtypes_url) }
      format.xml  { head :ok }
    end
  end
end
