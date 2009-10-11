class TasksController < ApplicationController
  def index
    @tasks = Tasks.all
  end
  
  def show
    @tasks = Tasks.find(params[:id])
  end
  
  def new
    @tasks = Tasks.new
  end
  
  def create
    @tasks = Tasks.new(params[:tasks])
    if @tasks.save
      flash[:notice] = "Successfully created tasks."
      redirect_to @tasks
    else
      render :action => 'new'
    end
  end
  
  def edit
    @tasks = Tasks.find(params[:id])
  end
  
  def update
    @tasks = Tasks.find(params[:id])
    if @tasks.update_attributes(params[:tasks])
      flash[:notice] = "Successfully updated tasks."
      redirect_to @tasks
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @tasks = Tasks.find(params[:id])
    @tasks.destroy
    flash[:notice] = "Successfully destroyed tasks."
    redirect_to tasks_url
  end
end
