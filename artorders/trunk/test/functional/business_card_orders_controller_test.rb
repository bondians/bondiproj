require 'test_helper'

class BusinessCardOrdersControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => BusinessCardOrder.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    BusinessCardOrder.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    BusinessCardOrder.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to business_card_order_url(assigns(:business_card_order))
  end
  
  def test_edit
    get :edit, :id => BusinessCardOrder.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    BusinessCardOrder.any_instance.stubs(:valid?).returns(false)
    put :update, :id => BusinessCardOrder.first
    assert_template 'edit'
  end
  
  def test_update_valid
    BusinessCardOrder.any_instance.stubs(:valid?).returns(true)
    put :update, :id => BusinessCardOrder.first
    assert_redirected_to business_card_order_url(assigns(:business_card_order))
  end
  
  def test_destroy
    business_card_order = BusinessCardOrder.first
    delete :destroy, :id => business_card_order
    assert_redirected_to business_card_orders_url
    assert !BusinessCardOrder.exists?(business_card_order.id)
  end
end
