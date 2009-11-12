class JobsController < ApplicationController
  def index
    #flows = Workflow.newunshipped.merge(Workflow.unshipped)
    #@jobs = flows.collect { |flow| Job.find(flow.job_id) }
    
    @jobs = Workflow.newunshipped.concat(Workflow.unshipped).collect { |flow| Job.find(flow.job_id) }
    #puts "these: " + theses.to_yaml
    #@jobs = Job.all
   # puts @jobs.to_yaml
  end
  
  def show
    @job = Job.find(params[:id])
    @workflows = Workflow.find(:all, :conditions => ['job_id = ?', @job.id])
   # @tasks = Task.find(:all)
  end
  
  def new
    @job = Job.new
    @job[:input_person] = current_user.username
    @job.workflows.build :name => "Design", :completed => "0"
    @job.workflows.build :name => "Copy" , :completed => "0"
    @job.workflows.build :name => "Press", :completed => "0"
    @job.workflows.build :name => "Bindry", :completed => "0"
    @job.workflows.build :name => "Ship" , :step_needed => "1"
   # @job.department.build
  end
  
  def create
   @job = Job.new(params[:job])
    # raise @jobs.to_yaml
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
      redirect_to jobs_path
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
