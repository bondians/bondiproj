require 'test_helper'

class OversuppliesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Oversupply.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Oversupply.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Oversupply.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to oversupply_url(assigns(:oversupply))
  end
  
  def test_edit
    get :edit, :id => Oversupply.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Oversupply.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Oversupply.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Oversupply.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Oversupply.first
    assert_redirected_to oversupply_url(assigns(:oversupply))
  end
  
  def test_destroy
    oversupply = Oversupply.first
    delete :destroy, :id => oversupply
    assert_redirected_to oversupplies_url
    assert !Oversupply.exists?(oversupply.id)
  end
end
