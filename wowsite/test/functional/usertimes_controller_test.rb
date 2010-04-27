require 'test_helper'

class UsertimesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:usertimes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create usertime" do
    assert_difference('Usertime.count') do
      post :create, :usertime => { }
    end

    assert_redirected_to usertime_path(assigns(:usertime))
  end

  test "should show usertime" do
    get :show, :id => usertimes(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => usertimes(:one).to_param
    assert_response :success
  end

  test "should update usertime" do
    put :update, :id => usertimes(:one).to_param, :usertime => { }
    assert_redirected_to usertime_path(assigns(:usertime))
  end

  test "should destroy usertime" do
    assert_difference('Usertime.count', -1) do
      delete :destroy, :id => usertimes(:one).to_param
    end

    assert_redirected_to usertimes_path
  end
end
