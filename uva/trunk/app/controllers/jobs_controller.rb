class JobsController < ApplicationController
  access_control do   
     allow logged_in
     allow anonymous, :to => [:index]
  end

  def index
    if params[:show] != nil
      puts "entered show search***"
      workflowClass = params[:show]
      if workflowClass =~ /design/ then
        @jobs = Job.search :conditions => { :current_workflow => 'Design' }
        @thisView = "Jobs - Design"
      elsif workflowClass =~ /copy/ then
        @jobs = Job.search :conditions => { :current_workflow => "copy" }
        @thisView = "Jobs - Copy"
      elsif workflowClass =~ /press/ then
        @jobs = Job.search :conditions => { :current_workflow => "press" }
        @thisView = "Jobs - Press"
      elsif workflowClass =~ /bindery/ then
        @jobs = Job.search :conditions => { :current_workflow => 'Bind' }
        @thisView = "Jobs - Bindery"
      elsif workflowClass =~ /ship/ then
        @jobs = Job.search :conditions => { :current_workflow => "Ship" }
        @thisView = "Jobs - Ship"
      elsif workflowClass =~ /in_process/ then
        @jobs = Job.find(:all, :conditions => ["completed = ?", false])
        @thisView = "Jobs - In Process"
      elsif workflowClass =~ /completed/ then
        @jobs = Job.find(:all, :conditions => ["completed = ?", true])
        @thisView = "Jobs - Completed"
      elsif workflowClass =~ /all/ then
        @jobs = Job.all
        @thisView = "Jobs - All"
      else 
        @jobs = Job.all
        @thisView = "Jobs - All"
      end 


    elsif   params[:search].nil?
      @jobs = Job.search :with => { :completed => false }, :order => :due_date
      @thisView = "Jobs - Incomplete"
    else
      @jobs = Job.search params[:search]
      @thisView = "Jobs - '#{params[:search]}'"
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
