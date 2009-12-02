class JobsController < ApplicationController
  access_control do   
     allow logged_in
     allow anonymous, :to => [:index]
  end

  def index
    if params[:search].nil?
      @jobs = Job.all :order => :due_date
    else
      @jobs = Job.search params[:search] #, :include => :workflow_note
    end
  end

  
  def show
    @job = Job.find(params[:id])
    @workflows = Workflow.find(:all, :conditions => ['job_id = ?', @job.id])
   # @tasks = Task.find(:all)
  end
  
  def new
    @job = Job.new
    @accounts = Account.all
    @departments = Department.all
    @job[:input_person] = current_user.username
    @job.workflows.build :name => "Design", :order => 10
    @job.workflows.build :name => "Copy" , :order => 70
    @job.workflows.build :name => "Press", :order => 80
    @job.workflows.build :name => "Bindery", :order => 90
    @job.workflows.build :name => "Ship", :order => 100, :step_needed => "1"
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
    @accounts = Account.all
    @departments = Department.all
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
