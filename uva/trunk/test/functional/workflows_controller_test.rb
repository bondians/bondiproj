require 'test_helper'

class WorkflowsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Workflow.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Workflow.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Workflow.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to workflow_url(assigns(:workflow))
  end
  
  def test_edit
    get :edit, :id => Workflow.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Workflow.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Workflow.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Workflow.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Workflow.first
    assert_redirected_to workflow_url(assigns(:workflow))
  end
  
  def test_destroy
    workflow = Workflow.first
    delete :destroy, :id => workflow
    assert_redirected_to workflows_url
    assert !Workflow.exists?(workflow.id)
  end
end
