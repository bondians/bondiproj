require 'test_helper'

class PersiphonesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:persiphones)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create persiphone" do
    assert_difference('Persiphone.count') do
      post :create, :persiphone => { }
    end

    assert_redirected_to persiphone_path(assigns(:persiphone))
  end

  test "should show persiphone" do
    get :show, :id => persiphones(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => persiphones(:one).to_param
    assert_response :success
  end

  test "should update persiphone" do
    put :update, :id => persiphones(:one).to_param, :persiphone => { }
    assert_redirected_to persiphone_path(assigns(:persiphone))
  end

  test "should destroy persiphone" do
    assert_difference('Persiphone.count', -1) do
      delete :destroy, :id => persiphones(:one).to_param
    end

    assert_redirected_to persiphones_path
  end
end
