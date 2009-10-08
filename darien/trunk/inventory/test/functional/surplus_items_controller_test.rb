require 'test_helper'

class SurplusItemsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => SurplusItems.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    SurplusItems.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    SurplusItems.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to surplus_items_url(assigns(:surplus_items))
  end
  
  def test_edit
    get :edit, :id => SurplusItems.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    SurplusItems.any_instance.stubs(:valid?).returns(false)
    put :update, :id => SurplusItems.first
    assert_template 'edit'
  end
  
  def test_update_valid
    SurplusItems.any_instance.stubs(:valid?).returns(true)
    put :update, :id => SurplusItems.first
    assert_redirected_to surplus_items_url(assigns(:surplus_items))
  end
  
  def test_destroy
    surplus_items = SurplusItems.first
    delete :destroy, :id => surplus_items
    assert_redirected_to surplus_items_url
    assert !SurplusItems.exists?(surplus_items.id)
  end
end
