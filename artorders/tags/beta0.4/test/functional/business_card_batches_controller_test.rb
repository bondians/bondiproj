require 'test_helper'

class BusinessCardBatchesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => BusinessCardBatch.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    BusinessCardBatch.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    BusinessCardBatch.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to business_card_batch_url(assigns(:business_card_batch))
  end
  
  def test_edit
    get :edit, :id => BusinessCardBatch.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    BusinessCardBatch.any_instance.stubs(:valid?).returns(false)
    put :update, :id => BusinessCardBatch.first
    assert_template 'edit'
  end
  
  def test_update_valid
    BusinessCardBatch.any_instance.stubs(:valid?).returns(true)
    put :update, :id => BusinessCardBatch.first
    assert_redirected_to business_card_batch_url(assigns(:business_card_batch))
  end
  
  def test_destroy
    business_card_batch = BusinessCardBatch.first
    delete :destroy, :id => business_card_batch
    assert_redirected_to business_card_batches_url
    assert !BusinessCardBatch.exists?(business_card_batch.id)
  end
end
