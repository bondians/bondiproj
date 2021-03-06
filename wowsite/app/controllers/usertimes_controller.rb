class UsertimesController < ApplicationController

  def index
    @users = Goldberg::User.all.select {|m| !m.usertimes.empty?}
    allTimes = @users.map{|m| Usertime.reversetimes m}
    @times = allTimes.transpose
    
  end
  
  def show
    begin
      @user = Goldberg::User.find params[:id]
    rescue
    end
    
    @user ||= Goldberg.user
    @times = Usertime.buildtimes(@user)
  end

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

end
