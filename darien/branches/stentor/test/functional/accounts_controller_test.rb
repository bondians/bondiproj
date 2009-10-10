require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Accounts.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Accounts.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Accounts.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to accounts_url(assigns(:accounts))
  end
  
  def test_edit
    get :edit, :id => Accounts.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Accounts.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Accounts.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Accounts.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Accounts.first
    assert_redirected_to accounts_url(assigns(:accounts))
  end
  
  def test_destroy
    accounts = Accounts.first
    delete :destroy, :id => accounts
    assert_redirected_to accounts_url
    assert !Accounts.exists?(accounts.id)
  end
end
