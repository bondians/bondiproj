class WorkflowsController < ApplicationController
  access_control do   
     allow logged_in
  end

  def index
    @workflows = Workflow.all
  end
  
  def show
    @workflow = Workflow.find(params[:id])
  end
  
  def new
    @workflow = Workflow.new
  end
  
  def create
    @workflow = Workflow.new(params[:workflow])
    if @workflow.save
      flash[:notice] = "Successfully created workflow."
      redirect_to @workflow
    else
      render :action => 'new'
    end
  end
  
  def edit
    @workflow = Workflow.find(params[:id])
  end
  
  def update
    @workflow = Workflow.find(params[:id])
    if @workflow.update_attributes(params[:workflow])
      flash[:notice] = "Successfully updated workflow."
      redirect_to @workflow
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @workflow = Workflow.find(params[:id])
    @workflow.destroy
    flash[:notice] = "Successfully destroyed workflow."
    redirect_to workflows_url
  end
end
