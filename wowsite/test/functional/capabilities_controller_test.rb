require 'test_helper'

class CapabilitiesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:capabilities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create capability" do
    assert_difference('Capability.count') do
      post :create, :capability => { }
    end

    assert_redirected_to capability_path(assigns(:capability))
  end

  test "should show capability" do
    get :show, :id => capabilities(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => capabilities(:one).to_param
    assert_response :success
  end

  test "should update capability" do
    put :update, :id => capabilities(:one).to_param, :capability => { }
    assert_redirected_to capability_path(assigns(:capability))
  end

  test "should destroy capability" do
    assert_difference('Capability.count', -1) do
      delete :destroy, :id => capabilities(:one).to_param
    end

    assert_redirected_to capabilities_path
  end
end
