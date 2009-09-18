class PersiphonesController < ApplicationController
  # GET /persiphones
  # GET /persiphones.xml
  def index
    @persiphones = Persiphone.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @persiphones }
    end
  end

  # GET /persiphones/1
  # GET /persiphones/1.xml
  def show
    @persiphone = Persiphone.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @persiphone }
    end
  end

  # GET /persiphones/new
  # GET /persiphones/new.xml
  def new
    @persiphone = Persiphone.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @persiphone }
    end
  end

  # GET /persiphones/1/edit
  def edit
    @persiphone = Persiphone.find(params[:id])
  end

  # POST /persiphones
  # POST /persiphones.xml
  def create
    @persiphone = Persiphone.new(params[:persiphone])

    respond_to do |format|
      if @persiphone.save
        flash[:notice] = 'Persiphone was successfully created.'
        format.html { redirect_to(@persiphone) }
        format.xml  { render :xml => @persiphone, :status => :created, :location => @persiphone }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @persiphone.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /persiphones/1
  # PUT /persiphones/1.xml
  def update
    @persiphone = Persiphone.find(params[:id])

    respond_to do |format|
      if @persiphone.update_attributes(params[:persiphone])
        flash[:notice] = 'Persiphone was successfully updated.'
        format.html { redirect_to(@persiphone) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @persiphone.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /persiphones/1
  # DELETE /persiphones/1.xml
  def destroy
    @persiphone = Persiphone.find(params[:id])
    @persiphone.destroy

    respond_to do |format|
      format.html { redirect_to(persiphones_url) }
      format.xml  { head :ok }
    end
  end
end
