require 'test_helper'

class CullsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:culls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cull" do
    assert_difference('Cull.count') do
      post :create, :cull => { }
    end

    assert_redirected_to cull_path(assigns(:cull))
  end

  test "should show cull" do
    get :show, :id => culls(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => culls(:one).to_param
    assert_response :success
  end

  test "should update cull" do
    put :update, :id => culls(:one).to_param, :cull => { }
    assert_redirected_to cull_path(assigns(:cull))
  end

  test "should destroy cull" do
    assert_difference('Cull.count', -1) do
      delete :destroy, :id => culls(:one).to_param
    end

    assert_redirected_to culls_path
  end
end
