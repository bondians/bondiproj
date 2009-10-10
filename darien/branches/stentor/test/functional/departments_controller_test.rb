require 'test_helper'

class DepartmentsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Departments.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Departments.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Departments.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to departments_url(assigns(:departments))
  end
  
  def test_edit
    get :edit, :id => Departments.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Departments.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Departments.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Departments.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Departments.first
    assert_redirected_to departments_url(assigns(:departments))
  end
  
  def test_destroy
    departments = Departments.first
    delete :destroy, :id => departments
    assert_redirected_to departments_url
    assert !Departments.exists?(departments.id)
  end
end
