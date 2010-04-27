class UsertimesController < ApplicationController
  # GET /usertimes
  # GET /usertimes.xml
  def index
    usertimes = Goldberg.user.usertimes
    @times = []
    24.times do |t|
      this_time = (usertimes.find_by_keytime t) || usertimes.build(:attributes => {:keytime => t})
      @times.push this_time
    end
  end

  # GET /usertimes/1
  # GET /usertimes/1.xml
  def show
    @usertime = Usertime.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @usertime }
    end
  end

  # GET /usertimes/new
  # GET /usertimes/new.xml
  def new
  end

  # GET /usertimes/1/edit
  # GET /students/1/edit
  def edit
    if params[:with][:id].to_i > 0
      @usertime = (Usertime.find params[:with][:id])
    else
      @usertime = Goldberg.user.usertimes.build(:attributes => {:keytime => params[:with][:keytime]})
    end
    
    case params[:with][:day]
    when "sun"
      @usertime.sun = !@usertime.sun
    when "mon"
      @usertime.mon = !@usertime.mon
    when "tue"
      @usertime.tue = !@usertime.tue
    when "wed"
      @usertime.wed = !@usertime.wed
    when "thu"
      @usertime.thu = !@usertime.thu
    when "fri"
      @usertime.fri = !@usertime.fri
    when "sat"
      @usertime.sat = !@usertime.sat
    end
    
    if @usertime.save!
      respond_to do |format|
        format.js
      end
    else
      flash[:error] = "Unable to Update"
      render :action => :index
    end
    
  end

  # POST /usertimes
  # POST /usertimes.xml
  def create
    @usertime = Usertime.new(params[:usertime])

    respond_to do |format|
      if @usertime.save
        flash[:notice] = 'Usertime was successfully created.'
        format.html { redirect_to(@usertime) }
        format.xml  { render :xml => @usertime, :status => :created, :location => @usertime }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @usertime.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /usertimes/1
  # PUT /usertimes/1.xml
  def update
    @usertime = Usertime.find(params[:id])

    respond_to do |format|
      if @usertime.update_attributes(params[:usertime])
        flash[:notice] = 'Usertime was successfully updated.'
        format.html { redirect_to(@usertime) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @usertime.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /usertimes/1
  # DELETE /usertimes/1.xml
  def destroy
    @usertime = Usertime.find(params[:id])
    @usertime.destroy

    respond_to do |format|
      format.html { redirect_to(usertimes_url) }
      format.xml  { head :ok }
    end
  end
end
