class SurplusItemsController < ApplicationController
  def index
    @surplus_items = SurplusItems.all
  end
  
  def show
    @surplus_items = SurplusItems.find(params[:id])
  end
  
  def new
    @surplus_items = SurplusItems.new
  end
  
  def create
    @surplus_items = SurplusItems.new(params[:surplus_items])
    if @surplus_items.save
      flash[:notice] = "Successfully created surplus items."
      redirect_to @surplus_items
    else
      render :action => 'new'
    end
  end
  
  def edit
    @surplus_items = SurplusItems.find(params[:id])
  end
  
  def update
    @surplus_items = SurplusItems.find(params[:id])
    if @surplus_items.update_attributes(params[:surplus_items])
      flash[:notice] = "Successfully updated surplus items."
      redirect_to @surplus_items
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @surplus_items = SurplusItems.find(params[:id])
    @surplus_items.destroy
    flash[:notice] = "Successfully destroyed surplus items."
    redirect_to surplus_items_url
  end
end
