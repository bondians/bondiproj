require 'test_helper'

class BusinessCardsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => BusinessCard.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    BusinessCard.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    BusinessCard.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to business_card_url(assigns(:business_card))
  end
  
  def test_edit
    get :edit, :id => BusinessCard.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    BusinessCard.any_instance.stubs(:valid?).returns(false)
    put :update, :id => BusinessCard.first
    assert_template 'edit'
  end
  
  def test_update_valid
    BusinessCard.any_instance.stubs(:valid?).returns(true)
    put :update, :id => BusinessCard.first
    assert_redirected_to business_card_url(assigns(:business_card))
  end
  
  def test_destroy
    business_card = BusinessCard.first
    delete :destroy, :id => business_card
    assert_redirected_to business_cards_url
    assert !BusinessCard.exists?(business_card.id)
  end
end
