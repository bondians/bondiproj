class BusinessCardBatchesController < ApplicationController
  def index
    @business_card_batches = BusinessCardBatch.all
  end
  
  def show
    @business_card_batch = BusinessCardBatch.find(params[:id])
  end
  
  def new
    @business_card_batch = BusinessCardBatch.new
  end
  
  def create
    @business_card_batch = BusinessCardBatch.new(params[:business_card_batch])
    if @business_card_batch.save
      flash[:notice] = "Successfully created business card batch."
      redirect_to @business_card_batch
    else
      render :action => 'new'
    end
  end
  
  def edit
    @business_card_batch = BusinessCardBatch.find(params[:id])
  end
  
  def update
    @business_card_batch = BusinessCardBatch.find(params[:id])
    if @business_card_batch.update_attributes(params[:business_card_batch])
      flash[:notice] = "Successfully updated business card batch."
      redirect_to @business_card_batch
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @business_card_batch = BusinessCardBatch.find(params[:id])
    @business_card_batch.destroy
    flash[:notice] = "Successfully destroyed business card batch."
    redirect_to business_card_batches_url
  end
end
