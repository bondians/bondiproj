class DepartmentsController < ApplicationController
  def index
    @departments = Departments.all
  end
  
  def show
    @departments = Departments.find(params[:id])
  end
  
  def new
    @departments = Departments.new
  end
  
  def create
    @departments = Departments.new(params[:departments])
    if @departments.save
      flash[:notice] = "Successfully created departments."
      redirect_to @departments
    else
      render :action => 'new'
    end
  end
  
  def edit
    @departments = Departments.find(params[:id])
  end
  
  def update
    @departments = Departments.find(params[:id])
    if @departments.update_attributes(params[:departments])
      flash[:notice] = "Successfully updated departments."
      redirect_to @departments
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @departments = Departments.find(params[:id])
    @departments.destroy
    flash[:notice] = "Successfully destroyed departments."
    redirect_to departments_url
  end
end
