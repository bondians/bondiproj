class JobsController < ApplicationController
  access_control do   
     allow logged_in
     allow anonymous, :to => [:index]
  end

  def index
        @jobs = Job.all.sort_by{ |m| m.due_date }
        @thisView = "Jobs - All"
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
    @job.department_id = nil if @job.department_id == ""
    @job.account_id = nil if @job.account_id == ""
    if @job.save
      flash[:notice] = "Successfully created job."
      redirect_to jobs_path
    else
      flash[:error] = "You must have a 'Name' and a 'Due date' set."
      render :action => 'new'
    end
  end
  
  def edit
    @accounts = Account.all
    @departments = Department.all
    @job = Job.find(params[:id])
  #  @workflows = Workflows.find_by_job_id(params[:id])
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
  
  def design
    
    @jobs = Job.search :conditions => { :current_workflow => 'Design' }, :order => :due_date
    @thisView = "Jobs - Design"
    render :template => "jobs/index"
  end

  def copy

    @jobs = Job.search :conditions => { :current_workflow => "Copy" }, :order => :due_date
    @thisView = "Jobs - Copy"
    render :template => "jobs/index"
  end

  def press

    @jobs = Job.search :conditions => { :current_workflow => "Press" }, :order => :due_date
    @thisView = "Jobs - Press"
    render :template => "jobs/index"
  end

  def bindery

    @jobs = Job.search :conditions => { :current_workflow => 'Bindery' }, :order => :due_date
    @thisView = "Jobs - Bindery"
    render :template => "jobs/index"
  end

  def ship

    @jobs = Job.search :conditions => { :current_workflow => "Ship" }, :order => :due_date
    @thisView = "Jobs - Ship"
    render :template => "jobs/index"
  end

  def current

    @jobs = Job.find(:all, :conditions => ["completed = ?", false]).sort_by{ |m| m.due_date }
    @thisView = "Jobs - Current"
    render :template => "jobs/index"
  end

  def completed 

    @jobs = Job.find(:all, :conditions => ["completed = ?", true]).sort_by{ |m| m.due_date }
    @thisView = "Jobs - Complete"
    render :template => "jobs/index"
  end

  def search

    @jobs = Job.search params[:search], :order => :due_date
    @thisView = "Jobs - '#{params[:search]}'"
    render :template => "jobs/index"
  end

  def complete_step
    job = Job.find(params[:id])
    step = Workflow.find(job.workflow_id)
    step.completed = true
    step.completed_date = Time.now
    step.save
    redirect_to :back

  end
  
end
