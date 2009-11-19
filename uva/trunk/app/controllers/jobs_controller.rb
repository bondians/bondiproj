class JobsController < ApplicationController
  access_control do   
     allow logged_in
     allow anonymous, :to => [:index]
  end

  def index
    # FIXME remove this stuff when you're satisfied it's not the way to go, probably real soon
#   if params[:show] == "all"
#     @thisView = "Jobs: All"
#     @jobs = Job.all :order => :due_date
#   elsif params[:show] == "shipped"
#     @thisView = "Jobs: Completed"
#     @jobs = Workflow.shipped.collect { |flow| Job.find(flow.job_id) }       
#     @jobs.sort! { |a,b| a.due_date <=> b.due_date }
#   elsif params[:search] != nil
#     @thisView = "Jobs: Search Results - #{params[:search]}"
#     @jobs = Job.search(params[:search])
#     #@items = Item.search(params[:search]
#   else
#     @thisView = "Jobs: In Process" 
#     @jobs = Workflow.newunshipped.concat(Workflow.unshipped).collect { |flow| Job.find(flow.job_id) }
#      @jobs.sort! { |a,b| a.due_date <=> b.due_date }          
#    end

    #@jobs = Workflow.newunshipped.concat(Workflow.unshipped).collect { |flow| Job.find(flow.job_id) }
    #@jobs = Job.all :order => :due_date 
#    @jobs
    @jobs = Job.search params[:search]
  end

#  def index
#    respond_to do |format|
#      format.html do
#        @page = params[:page] || 1
#        @items = Item.search(params[:search], @page)
#      end
#      format.pdf do
#        @items = Item.all :order => :itemtype_id, :include => :prices
#      end
#    end
#  end

  
  def show
    @job = Job.find(params[:id])
    @workflows = Workflow.find(:all, :conditions => ['job_id = ?', @job.id])
   # @tasks = Task.find(:all)
  end
  
  def new
    @job = Job.new
    @job[:input_person] = current_user.username
    @job.workflows.build :name => "Design", :order => 10
    @job.workflows.build :name => "Copy" , :order => 70
    @job.workflows.build :name => "Press", :order => 80
    @job.workflows.build :name => "Bindry", :order => 90
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
