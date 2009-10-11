class BcSchoolsController < ApplicationController
  def index
    @bc_schools = BcSchool.all
  end
  
  def show
    @bc_school = BcSchool.find(params[:id])
  end
  
  def new
    @bc_school = BcSchool.new
  end
  
  def create
    @bc_school = BcSchool.new(params[:bc_school])
    if @bc_school.save
      flash[:notice] = "Successfully created bc school."
      redirect_to @bc_school
    else
      render :action => 'new'
    end
  end
  
  def edit
    @bc_school = BcSchool.find(params[:id])
  end
  
  def update
    @bc_school = BcSchool.find(params[:id])
    if @bc_school.update_attributes(params[:bc_school])
      flash[:notice] = "Successfully updated bc school."
      redirect_to @bc_school
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @bc_school = BcSchool.find(params[:id])
    @bc_school.destroy
    flash[:notice] = "Successfully destroyed bc school."
    redirect_to bc_schools_url
  end
end
