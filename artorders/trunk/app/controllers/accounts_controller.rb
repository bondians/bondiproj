class AccountsController < ApplicationController
  def index
    @accounts = Accounts.all
  end
  
  def show
    @accounts = Accounts.find(params[:id])
  end
  
  def new
    @accounts = Accounts.new
  end
  
  def create
    @accounts = Accounts.new(params[:accounts])
    if @accounts.save
      flash[:notice] = "Successfully created accounts."
      redirect_to @accounts
    else
      render :action => 'new'
    end
  end
  
  def edit
    @accounts = Accounts.find(params[:id])
  end
  
  def update
    @accounts = Accounts.find(params[:id])
    if @accounts.update_attributes(params[:accounts])
      flash[:notice] = "Successfully updated accounts."
      redirect_to @accounts
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @accounts = Accounts.find(params[:id])
    @accounts.destroy
    flash[:notice] = "Successfully destroyed accounts."
    redirect_to accounts_url
  end
end
