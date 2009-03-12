class PlentriesController < ApplicationController
  # GET /plentries
  # GET /plentries.xml
  def index
    @plentries = Plentry.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @plentries }
    end
  end

  # GET /plentries/1
  # GET /plentries/1.xml
  def show
    @plentry = Plentry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @plentry }
    end
  end

  # GET /plentries/new
  # GET /plentries/new.xml
  def new
    @plentry = Plentry.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @plentry }
    end
  end

  # GET /plentries/1/edit
  def edit
    @plentry = Plentry.find(params[:id])
  end

  # POST /plentries
  # POST /plentries.xml
  def create
    @plentry = Plentry.new(params[:plentry])

    respond_to do |format|
      if @plentry.save
        flash[:notice] = 'Plentry was successfully created.'
        format.html { redirect_to(@plentry) }
        format.xml  { render :xml => @plentry, :status => :created, :location => @plentry }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @plentry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /plentries/1
  # PUT /plentries/1.xml
  def update
    @plentry = Plentry.find(params[:id])

    respond_to do |format|
      if @plentry.update_attributes(params[:plentry])
        flash[:notice] = 'Plentry was successfully updated.'
        format.html { redirect_to(@plentry) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @plentry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /plentries/1
  # DELETE /plentries/1.xml
  def destroy
    @plentry = Plentry.find(params[:id])
    @plentry.destroy

    respond_to do |format|
      format.html { redirect_to(plentries_url) }
      format.xml  { head :ok }
    end
  end
end
