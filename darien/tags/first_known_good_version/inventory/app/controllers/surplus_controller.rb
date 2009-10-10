class SurplusController < ApplicationController  
  #skip_before_filter :verify_authenticity_token 
  #protect_from_forgery :except => [:from_pdf]
  def index
    @surplus = Surplus.all
  end
  
  def show
    @surplus = Surplus.find(params[:id])
  end
  
  def new
    @surplus = Surplus.new
    #cgi = CGI.new
    @surplus.from = params['FROM'] 
    @surplus.save
    render :text => "Received"    
  end
  
  def create
    @surplus = Surplus.new(params[:surplus])
    if @surplus.save
      flash[:notice] = "Successfully created surplus."
      redirect_to @surplus
    else
      render :action => 'new'
    end
  end
  
  def edit
    @surplus = Surplus.find(params[:id])
  end
  
  def update
    @surplus = Surplus.find(params[:id])
    if @surplus.update_attributes(params[:surplus])
      flash[:notice] = "Successfully updated surplus."
      redirect_to @surplus
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @surplus = Surplus.find(params[:id])
    @surplus.destroy
    flash[:notice] = "Successfully destroyed surplus."
    redirect_to surplus_url
  end
end

def from_surplus
   @surplus = Surplus.new
   cgi = CGI.new
   @surplus.name = cgi['FROM'] 
   @surplus.save
end