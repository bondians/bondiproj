require 'test_helper'

class BcSchoolsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => BcSchool.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    BcSchool.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    BcSchool.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to bc_school_url(assigns(:bc_school))
  end
  
  def test_edit
    get :edit, :id => BcSchool.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    BcSchool.any_instance.stubs(:valid?).returns(false)
    put :update, :id => BcSchool.first
    assert_template 'edit'
  end
  
  def test_update_valid
    BcSchool.any_instance.stubs(:valid?).returns(true)
    put :update, :id => BcSchool.first
    assert_redirected_to bc_school_url(assigns(:bc_school))
  end
  
  def test_destroy
    bc_school = BcSchool.first
    delete :destroy, :id => bc_school
    assert_redirected_to bc_schools_url
    assert !BcSchool.exists?(bc_school.id)
  end
end
