class JobsController < ApplicationController
  access_control do   
     allow logged_in
     allow anonymous, :to => [:index, :search]
    # layout "standard"
  end

  def index
        @jobs = Job.all :order => 'due'
        @thisView = "Jobs - All"
  end

  
  def show
    @job = Job.find(params[:id])
    @workflows = Workflow.find(:all, :conditions => ['job_id = ?', @job.id]).sort_by{ |m| m.order }
   # @tasks = Task.find(:all)
  end
  
  def new
    @job = Job.new
    @accounts = Account.all
    @departments = Department.all
    @job[:input_person] = current_user.username
    @job[:dept] = ""
    @job[:acct] = ""
    d = Task.find_by_name("Design")
    c = Task.find_by_name("Copy")
    p = Task.find_by_name("Press")
    b = Task.find_by_name("Bindery")
    s = Task.find_by_name("Ship")
    @job.workflows.build :name => "Design", :order => 10, :step_needed => "0", :completed => false, :task_id => d.id
    @job.workflows.build :name => "Copy" , :order => 70, :step_needed => "0", :completed => false, :task_id => c.id
    @job.workflows.build :name => "Press", :order => 80, :step_needed => "0", :completed => false, :task_id => p.id
    @job.workflows.build :name => "Bindery", :order => 90, :step_needed => "0", :completed => false, :task_id => b.id
    @job.workflows.build :name => "Ship", :order => 100, :step_needed => "1", :completed => false, :task_id => s.id
   # @job.department.build
  end
  
  def new_from_template 
    job_template = Job.find(params[:id])
    @job = Job.new 

    @job[:name] = job_template[:name]
    @job[:description] = job_template[:description]
    @job[:due] = job_template[:due]
    @job[:submit_date] = job_template[:submit_date]
    @job[:received_date] = job_template[:received_date]
    @job[:ordered_by] = job_template[:ordered_by]
    @job[:auth_sig] = job_template[:auth_sig]
    #@job[:department_id] = job_template[:department_id]
    #@job[:account_id] = job_template[:account_id]

    @job[:dept] = dept2deptName(job_template.department)
    @job[:acct] = acct2acctNumber(job_template.account)

    @job[:input_person] = current_user.username

    @accounts = Account.all
    @departments = Department.all

    workflowSteps = Workflow.find(:all, :conditions => ["job_id = ?", job_template.id])
    workflowSteps.each do |step|
       # puts "how does .each work? ******************" 
        @job.workflows.build :name => step.name, :order => step.order, :note => step.note, :step_needed => "1", :task_id => step.task_id
    end
    #   @job.workflows.build :name => "Design", :order => 10
    #   @job.workflows.build :name => "Copy" , :order => 70
    #   @job.workflows.build :name => "Press", :order => 80
    #   @job.workflows.build :name => "Bindery", :order => 90
    #   @job.workflows.build :name => "Ship", :order => 100, :step_needed => "1"
    # @job.department.build 
    render :template => "jobs/edit"

  end

  def create
    depart = params[:job][:dept]
    acnt = params[:job][:acct] 
    @job = Job.new(params[:job])
    
    
    if depart == ( "" || nil )  then
      @job.department_id = nil 
    elsif Department.find_by_name(depart).nil?
      dept = Department.new
      dept.name = depart.upcase
      dept.save
      @job.department_id = dept.id 
    else 
      @job.department_id = Department.find_by_name(depart).id
    end 
    
    if acnt == ( "" || nil )  then
      @job.account_id = nil 
    elsif Account.find_by_number(acnt).nil?
      newAcct = Account.new
      newAcct.number = acnt
      newAcct.save
      @job.account_id = newAcct.id 
    else 
      @job.account_id = Account.find_by_number(acnt).id
    end 
    
    if @job.save
      flash[:notice] = "Successfully created job."
      redirect_to job_path(@job)
    else
      flash[:error] = "You must have a 'Name' and a 'Due date' set."
      render :action => 'new'
    end
  end

  def edit
    @accounts = Account.all
    @departments = Department.all
    @job = Job.find(params[:id])
    @job[:dept] = ( @job.department_id.nil? ? "" : @job.department.name )
    @job[:acct] = ( @job.account_id.nil? ? "" : @job.account.number )
  #  @workflows = Workflows.find_by_job_id(params[:id])
   # @workflows = Workflow.find(:all, :conditions => ['job_id = ?', @job.id])
    
  end
  
  def update
    @job = Job.find(params[:id])
    depart = params[:job][:dept]
    acnt = params[:job][:acct]

     if depart == ( "" || nil )  then
       params[:job][:department_id] = nil 
     elsif Department.find_by_name(depart).nil?
       dept = Department.new
       dept.name = depart.upcase
       dept.save
       params[:job][:department_id] = dept.id 
     else 
       params[:job][:department_id] = Department.find_by_name(depart).id   
     end 

    
    if acnt == ( "" || nil )  then
      params[:job][:account_id] = nil 
    elsif Account.find_by_number(acnt).nil?
      newAcct = Account.new
      newAcct.number = acnt
      newAcnt.save
      params[:job][:account_id] = newAcct.id 
    else 
      params[:job][:account_id] = Account.find_by_number(acnt).id
    end 

    if @job.update_attributes(params[:job])
      flash[:notice] = "Successfully updated job."
      redirect_to job_path(@job)
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
    d = Task.find_by_name("Design").id
    @jobs = Job.find(:all, :conditions => { :task_id => d }, :order => 'due'  )  #).sort_by{ |m| m.due }
   #  @jobs = (Workflow.find_by_sql("SELECT * FROM workflows WHERE name = 'Design' AND (completed IS NULL OR completed = 0)")).collect{|w| Job.find(w.job_id)}.sort{|a, b| b.due_date <=> a.due_date }
    # @jobs.sort_by(:due_date => DESC)
    # w.collect{|i| Job.find(i.job_id)}
    # @jobs = Job.search :conditions => { :current_workflow => 'Design' }, :order => :due_date
    @thisView = "Jobs - Design:#{@jobs.count} records"
    render :template => "jobs/index"
  end

  def copy
    d = Task.find_by_name("Copy").id
    @jobs = Job.find(:all, :conditions => { :task_id => d }, :order => 'due'  )  #).sort_by{ |m| m.due }
#    @jobs = (Workflow.find_by_sql("SELECT * FROM workflows WHERE name = 'Copy' AND (completed IS NULL OR completed = 0)")).collect{|w| Job.find(w.job_id)}.sort{|a, b| b.due_date <=> a.due_date }

  #  @jobs = Job.search :conditions => { :current_workflow => "Copy" }, :order => :due_date
    @thisView = "Jobs - Copy:#{@jobs.count} records"
    render :template => "jobs/index"
  end

  def press
    d = Task.find_by_name("Press").id
    @jobs = Job.find(:all, :conditions => { :task_id => d }, :order => 'due'  )  #).sort_by{ |m| m.due }
#    @jobs = (Workflow.find_by_sql("SELECT * FROM workflows WHERE name = 'Press' AND (completed IS NULL OR completed = 0)")).collect{|w| Job.find(w.job_id)}.sort{|a, b| b.due_date <=> a.due_date }

   # @jobs = Job.search :conditions => { :current_workflow => "Press" }, :order => :due_date
    @thisView = "Jobs - Press:#{@jobs.count} records"
    render :template => "jobs/index"
  end

  def bindery
    d = Task.find_by_name("Bindery").id
    @jobs = Job.find(:all, :conditions => { :task_id => d }, :order => 'due'  )  #).sort_by{ |m| m.due }
#    @jobs = (Workflow.find_by_sql("SELECT * FROM workflows WHERE name = 'Bindery' AND (completed IS NULL OR completed = 0)")).collect{|w| Job.find(w.job_id)}.sort{|a, b| b.due_date <=> a.due_date }

  #  @jobs = Job.search :conditions => { :current_workflow => 'Bindery' }, :order => :due_date
    @thisView = "Jobs - Bindery:#{@jobs.count} records"
    render :template => "jobs/index"
  end

  def ship
    d = Task.find_by_name("Ship").id
    @jobs = Job.find(:all, :conditions => { :task_id => d }, :order => 'due'  )  #).sort_by{ |m| m.due }
#    @jobs = (Workflow.find_by_sql("SELECT * FROM workflows WHERE name = 'Ship' AND (completed IS NULL OR completed = 0)")).collect{|w| Job.find(w.job_id)}.sort{|a, b| b.due_date <=> a.due_date }

  #  @jobs = Job.search :conditions => { :current_workflow => "Ship" }, :order => :due_date
    @thisView = "Jobs - Ship:#{@jobs.count} records"
    render :template => "jobs/index"
  end

  def current

    @jobs = Job.find(:all, :conditions => ["completed = ?", false], :order => 'due')#.sort_by{ |m| m.due }
    @thisView = "Jobs - Current:#{@jobs.count} records"
    render :template => "jobs/index"
  end

  def completed 

    @jobs = Job.find(:all, :conditions => ["completed = ?", true], :order => 'due')#.sort_by{ |m| m.due }
    @thisView = "Jobs - Complete:#{@jobs.count} records"
    render :template => "jobs/index"
  end

  def search

    @jobs = Job.search params[:search], :order => :due
    @thisView = "Jobs - '#{params[:search]}':#{@jobs.count} found"
    render :template => "jobs/index"
  end

  def search_by_school
    school = Department.find_by_name(params[:search]).id
    @jobs = Job.find(:all, :conditions => ["department_id = ?", school], :order => :due)
    @thisView = "Jobs - '#{params[:search]}':#{@jobs.count} found"
    render :template => "jobs/index"
  end

  def complete_step
    job = Job.find(params[:id])
    step = Workflow.find(job.workflow_id)
    step.complete_step
 #   step.completed = true
 #   step.completed_date = Time.now
 #   step.save
    redirect_to :back

  end  
  
  private
  
  def dept2deptName(deptID)
       #  
       dept = deptID.nil? ? "" : Department.find(deptID).name 
  end
  
  def deptName2dept(department)
       # 
        dept_id = department.nil? ? nil : Department.find_by_name(department)
  end 
  
  def acct2acctNumber(actID)
       #  
       act = actID.nil? ? "" : Account.find(actID).number 
  end
  
  def acctNumber2acct(account)
       # 
        acct_id = account.nil? ? nil : Account.find_by_number(account)
  end 
  
  
  
end
