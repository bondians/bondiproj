class AbusesController < ApplicationController
  # GET /abuses
  # GET /abuses.xml
  def index
    Abuse.first :offset=>rand(Abuse.all.length)
  end

  # GET /abuses/new
  # GET /abuses/new.xml
  def new
    @abuse = Abuse.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @abuse }
    end
  end

  # GET /abuses/1/edit
  def edit
    @abuse = Abuse.find(params[:id])
  end

  # POST /abuses
  # POST /abuses.xml
  def create
    @abuse = Abuse.new(params[:abuse])

    respond_to do |format|
      if @abuse.save
        flash[:notice] = 'Abuse was successfully created.'
        format.html { redirect_to(@abuse) }
        format.xml  { render :xml => @abuse, :status => :created, :location => @abuse }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @abuse.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /abuses/1
  # PUT /abuses/1.xml
  def update
    @abuse = Abuse.find(params[:id])

    respond_to do |format|
      if @abuse.update_attributes(params[:abuse])
        flash[:notice] = 'Abuse was successfully updated.'
        format.html { redirect_to(@abuse) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @abuse.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /abuses/1
  # DELETE /abuses/1.xml
  def destroy
    @abuse = Abuse.find(params[:id])
    @abuse.destroy

    respond_to do |format|
      format.html { redirect_to(abuses_url) }
      format.xml  { head :ok }
    end
  end
end
