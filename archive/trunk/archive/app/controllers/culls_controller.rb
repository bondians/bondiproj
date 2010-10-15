class CullsController < ApplicationController
  # GET /culls
  # GET /culls.xml
  def index
    @culls = Cull.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @culls }
    end
  end

  # GET /culls/1
  # GET /culls/1.xml
  def show
    @cull = Cull.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cull }
    end
  end

  # GET /culls/new
  # GET /culls/new.xml
  def new
    @cull = Cull.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cull }
    end
  end

  # GET /culls/1/edit
  def edit
    @cull = Cull.find(params[:id])
  end

  # POST /culls
  # POST /culls.xml
  def create
    @cull = Cull.new(params[:cull])

    respond_to do |format|
      if @cull.save
        flash[:notice] = 'Cull was successfully created.'
        format.html { redirect_to(@cull) }
        format.xml  { render :xml => @cull, :status => :created, :location => @cull }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cull.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /culls/1
  # PUT /culls/1.xml
  def update
    @cull = Cull.find(params[:id])

    respond_to do |format|
      if @cull.update_attributes(params[:cull])
        flash[:notice] = 'Cull was successfully updated.'
        format.html { redirect_to(@cull) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cull.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /culls/1
  # DELETE /culls/1.xml
  def destroy
    @cull = Cull.find(params[:id])
    @cull.destroy

    respond_to do |format|
      format.html { redirect_to(culls_url) }
      format.xml  { head :ok }
    end
  end
end
