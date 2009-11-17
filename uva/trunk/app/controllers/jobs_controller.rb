class JobsController < ApplicationController
  def index
    respond_to do |format|
      format.html do
        if params[:show] == "all"
          @jobs = Job.all :order => :due_date       
        else 
          @jobs = Workflow.newunshipped.concat(Workflow.unshipped).collect { |flow| Job.find(flow.job_id) }          
        end
      end
    end 

    #@jobs = Workflow.newunshipped.concat(Workflow.unshipped).collect { |flow| Job.find(flow.job_id) }
    #@jobs = Job.all :order => :due_date 
    @jobs
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
    @job.workflows.build :name => "Design"
    @job.workflows.build :name => "Copy" 
    @job.workflows.build :name => "Press"
    @job.workflows.build :name => "Bindry"
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
