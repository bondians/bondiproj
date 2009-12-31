class JobsController < ApplicationController
  access_control do   
    allow logged_in
    allow anonymous, :to => [:index, :search]
    # layout "standard"
  end

  def index
    @jobs = Job.all.sort_by{ |m| m.due }
    @thisView = "Jobs - All"
  end


  def show
    @job = Job.find(params[:id])
    @workflows = Workflow.find(:all, :conditions => ['job_id = ?', @job.id])
    @thisView = "Job - #{@job.id.to_s}"
    # @tasks = Task.find(:all)
  end

  def new
    @job = Job.new
    @accounts = Account.all
    @departments = Department.all
    @job[:input_person] = current_user.username
    @job[:dept] = ""
    @job[:acct] = ""
    @job.workflows.build :name => "Design", :order => 10
    @job.workflows.build :name => "Copy" , :order => 70
    @job.workflows.build :name => "Press", :order => 80
    @job.workflows.build :name => "Bindery", :order => 90
    @job.workflows.build :name => "Ship", :order => 100, :step_needed => "1"
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

    @job[:dept] = dept2deptName(job_template.department)
    @job[:acct] = acct2acctNumber(job_template.account)

    @job[:input_person] = current_user.username

    @accounts = Account.all
    @departments = Department.all

    workflowSteps = Workflow.find(:all, :conditions => ["job_id = ?", job_template.id])
    workflowSteps.each do |step|
      @job.workflows.build :name => step.name, :order => step.order, :note => step.note, :step_needed => "1"
    end
    render :template => "jobs/edit"

  end

  def create
    depart = params[:job][:dept]
    acnt = params[:job][:acct] 
    @job = Job.new(params[:job])

    # this is lame, but the only way I can get it to work the way I want
    # THE WAY I WANT: a javascript popdown with a list of department names the user selects. 
    # Without editing the javascript, it returns the NAME of the dept, not the ID, so 
    # I made a virtual attribute (methods that get and set values, based on real attributes) for "depart" to be the name of the department
    # Then I look up the ID by the name, with nil checking, and creation of previously non-existent departments.
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

    # I do the same lame thing for accounts
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
      flash[:notice] = "Successfully created job \##{@job.id}."
      redirect_to :action => 'show', :id => @job.id
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
  end

  def update
    @job = Job.find(params[:id])
    # raise @job.to_yaml

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
      flash[:notice] = "Successfully updated job \##{@job.id}."
      redirect_to job_path
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

    @jobs = Job.search :conditions => { :current_workflow => 'Design' }, :order => :due
    @thisView = "Jobs - Design"
    render :template => "jobs/index"
  end

  def copier

    @jobs = Job.search :conditions => { :current_workflow => 'Copy' }, :order => :due
    @thisView = "Jobs - Copy"
    render :template => "jobs/index"
  end

  def press

    @jobs = Job.search :conditions => { :current_workflow => "Press" }, :order => :due
    @thisView = "Jobs - Press"
    render :template => "jobs/index"
  end

  def bindery

    @jobs = Job.search :conditions => { :current_workflow => 'Bindery' }, :order => :due
    @thisView = "Jobs - Bindery"
    render :template => "jobs/index"
  end

  def ship

    @jobs = Job.search :conditions => { :current_workflow => "Ship" }, :order => :due
    @thisView = "Jobs - Ship"
    render :template => "jobs/index"
  end

  def current

    @jobs = Job.find(:all, :conditions => ["completed = ?", false]).sort_by{ |m| m.due }
    @thisView = "Jobs - Current"
    render :template => "jobs/index"
  end

  def completed 

    @jobs = Job.find(:all, :conditions => ["completed = ?", true]).sort_by{ |m| m.due }
    @thisView = "Jobs - Complete"
    render :template => "jobs/index"
  end

  def search

    @jobs = Job.search params[:search], :order => :due
    @thisView = "Jobs - '#{params[:search]}'"
    render :template => "jobs/index"
  end

  def complete_step
    job = Job.find(params[:id])
    step = Workflow.find(job.workflow_id)
    step.complete_step
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
