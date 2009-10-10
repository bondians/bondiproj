require 'test_helper'

class JobsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Jobs.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Jobs.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Jobs.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to jobs_url(assigns(:jobs))
  end
  
  def test_edit
    get :edit, :id => Jobs.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Jobs.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Jobs.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Jobs.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Jobs.first
    assert_redirected_to jobs_url(assigns(:jobs))
  end
  
  def test_destroy
    jobs = Jobs.first
    delete :destroy, :id => jobs
    assert_redirected_to jobs_url
    assert !Jobs.exists?(jobs.id)
  end
end
