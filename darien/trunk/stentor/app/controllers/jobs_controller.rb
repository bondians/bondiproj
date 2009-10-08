class JobsController < ApplicationController
  def index
    @jobs = Jobs.all
  end
  
  def show
    @jobs = Jobs.find(params[:id])
  end
  
  def new
    @jobs = Jobs.new
  end
  
  def create
    @jobs = Jobs.new(params[:jobs])
    if @jobs.save
      flash[:notice] = "Successfully created jobs."
      redirect_to @jobs
    else
      render :action => 'new'
    end
  end
  
  def edit
    @jobs = Jobs.find(params[:id])
  end
  
  def update
    @jobs = Jobs.find(params[:id])
    if @jobs.update_attributes(params[:jobs])
      flash[:notice] = "Successfully updated jobs."
      redirect_to @jobs
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @jobs = Jobs.find(params[:id])
    @jobs.destroy
    flash[:notice] = "Successfully destroyed jobs."
    redirect_to jobs_url
  end
end
