class AccountsController < ApplicationController
  access_control do   
     allow logged_in
     allow anonymous, :to => [:index]
  end

  def index 
    @accounts = Account.find(:all, :conditions => ['number LIKE ?', "%#{params[:search]}%"])

    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def show
    @account = Account.find(params[:id])
  end
  
  def new
    @account = Account.new
  end
  
  def create
    @account = Account.new(params[:account])
    if @account.save
      flash[:notice] = "Successfully created account."
      redirect_to @account
    else
      render :action => 'new'
    end
  end
  
  def edit
    @account = Account.find(params[:id])
  end
  
  def update
    @account = Account.find(params[:id])
    if @account.update_attributes(params[:account])
      flash[:notice] = "Successfully updated account."
      redirect_to @account
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @account = Account.find(params[:id])
    @account.destroy
    flash[:notice] = "Successfully destroyed account."
    redirect_to accounts_url
  end
end
