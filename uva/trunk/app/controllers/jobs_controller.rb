class JobsController < ApplicationController
  def index
    @jobs = Job.all
  end
  
  def show
    @job = Job.find(params[:id])
    @workflows = Workflow.find(:all, :conditions => ['job_id = ?', @job.id])
   # @tasks = Task.find(:all)
  end
  
  def new
    @job = Job.new
    @job[:input_person] = current_user.username
    @job.workflows.build :name => "Design"
    @job.workflows.build :name => "Copy"
    @job.workflows.build :name => "Press"
    @job.workflows.build :name => "Bindry"
    @job.workflows.build :name => "Ship"
  end
  
  def create
   @job = Job.new(params[:job])
    if @job.save
      flash[:notice] = "Successfully created job."
      redirect_to jobs_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @job = Job.find(params[:id])
   # @workflows = Workflow.find(:all, :conditions => ['job_id = ?', @job.id])
    
  end
  
  def update
    @job = Job.find(params[:id])
   # raise params.to_yaml
    if @job.update_attributes(params[:job])
      flash[:notice] = "Successfully updated job."
      redirect_to @job
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    flash[:notice] = "Successfully destroyed job."
    redirect_to jobs_url
  end
end
