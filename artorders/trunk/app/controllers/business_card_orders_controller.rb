class BusinessCardOrdersController < ApplicationController
  auto_complete_for :business_card_order, :name
  access_control do
     allow logged_in
     allow anonymous, :to => [:index, :show] 
  end
  
  def index
    @business_card_orders = BusinessCardOrder.find(:all, :order => "business_card_batch_id ASC, quantity DESC")
  end
  
  def show
    @business_card_order = BusinessCardOrder.find(params[:id])
  end
  
  def new
    @business_card_order = BusinessCardOrder.new
  end
  
  def create
    @business_card_order = BusinessCardOrder.new(params[:business_card_order])
    if @business_card_order.save
      @business_card_order.business_card.ordered = TRUE
      @business_card_order.business_card.save
      flash[:notice] = "Successfully created business card order."
      redirect_to @business_card_order
    else
      render :action => 'new'
    end
  end
  
  def edit
    @business_card_order = BusinessCardOrder.find(params[:id])
  end
  
  def update
    @business_card_order = BusinessCardOrder.find(params[:id])
    if @business_card_order.update_attributes(params[:business_card_order])
      @business_card_order.business_card.ordered = TRUE
      @business_card_order.business_card.save
      flash[:notice] = "Successfully updated business card order."
      redirect_to @business_card_order
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @business_card_order = BusinessCardOrder.find(params[:id])
    @business_card_order.destroy
    flash[:notice] = "Successfully destroyed business card order."
    redirect_to business_card_orders_url
  end
  
  def auto_complete_for_bc_name
    re = Regexp.new("^#{params[:business_card][:name]}", "i")
    find_options = { :order => "name ASC" }
    @names = BusinessCard.find(:all, find_options).collect(&:name).select { |namez| namez.match re }
    
    render :inline => "%< content_tag(:ul, @names.map { |namez| content_tag(:li, h(namez)) }) %>"
  end
end
