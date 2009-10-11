require 'test_helper'

class SurplusControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Surplus.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Surplus.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Surplus.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to surplus_url(assigns(:surplus))
  end
  
  def test_edit
    get :edit, :id => Surplus.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Surplus.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Surplus.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Surplus.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Surplus.first
    assert_redirected_to surplus_url(assigns(:surplus))
  end
  
  def test_destroy
    surplus = Surplus.first
    delete :destroy, :id => surplus
    assert_redirected_to surplus_url
    assert !Surplus.exists?(surplus.id)
  end
end
