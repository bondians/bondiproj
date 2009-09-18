class BusinessCardBatchesController < ApplicationController
  def index
    @business_card_batches = BusinessCardBatch.all
  end
  
  def show
    @business_card_batch = BusinessCardBatch.find(params[:id])
    @orders = BusinessCardOrder.find_all_by_business_card_batch_id(@business_card_batch.id)
  end
  
  def new
    @business_card_batch = BusinessCardBatch.new
    @business_card_batch.quantity = (BusinessCardOrder.not_completed.fewest_cards(1)).collect{ |t| t.quantity }.first
       
   # 3.times { @business_card_batch.business_card_orders.build }
    #do
     #   @business_card_batch.business_card_orders.build 
     #until current_up == cards_up
    
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
    cards_up = 20 
    current_up = 0
    full_batch = FALSE

    @business_card_batch = BusinessCardBatch.find(params[:id])
    batch_size = @business_card_batch.quantity
    if ( (BusinessCardOrder.not_completed.fewest_cards(1)).first != nil ) then
      while ( current_up < 20 || !full_batch ) do
       current_card = (BusinessCardOrder.not_completed.fewest_cards(1)).first
       overflow = ((current_card.quantity % batch_size == 0) ? 0 : 1 )
       if ((current_card.quantity / batch_size) + overflow ) <= (cards_up - current_up)
         current_card.business_card_batch_id = @business_card_batch.id
         current_up = current_up + ((current_card.quantity / batch_size) + overflow )
         current_card.save
       else
          full_batch = TRUE
       end
      end
    end 
    
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
  
  
  #private
  
  
end
