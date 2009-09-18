class BusinessCardsController < ApplicationController
  auto_complete_for :bc_school, :name
  def search
    @business_cards = BusinessCard.find(:all, :conditions => [ 'name LIKE ?', "%{params[:search]}%"])
  end
  
  def index
    
    respond_to do |format|
      format.html do
        @business_cards = BusinessCard.find(:all, :order => "ordered ASC")
      end # index.html
      format.xml do
         @business_cards = BusinessCard.all
         render :xml => @business_cards 
       end
       format.js do
         @business_cards = BusinessCard.find(:all, :conditions => [ 'name LIKE ?', "%#{params[:search]}%"]).collect(&:name)
         render :js => @business_cards
       end
    end
  end
  
  def show
    @business_card = BusinessCard.find(params[:id])
  end
  
  def new
    @business_card = BusinessCard.new
  end
  
  def create
    @business_card = BusinessCard.new(params[:business_card])
    if @business_card.save
      flash[:notice] = "Successfully created business card."
      redirect_to @business_card
    else
      render :action => 'new'
    end
  end
  
  def edit
    @business_card = BusinessCard.find(params[:id])
  end
  
  def update
    @business_card = BusinessCard.find(params[:id])
    if @business_card.update_attributes(params[:business_card])
      flash[:notice] = "Successfully updated business card."
      #redirect_to @business_card
      redirect_to business_cards_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @business_card = BusinessCard.find(params[:id])
    @business_card.destroy
    flash[:notice] = "Successfully destroyed business card."
    redirect_to business_cards_url
  end
end
