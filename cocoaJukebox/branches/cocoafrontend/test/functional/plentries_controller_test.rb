require 'test_helper'

class PlentriesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:plentries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create plentry" do
    assert_difference('Plentry.count') do
      post :create, :plentry => { }
    end

    assert_redirected_to plentry_path(assigns(:plentry))
  end

  test "should show plentry" do
    get :show, :id => plentries(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => plentries(:one).id
    assert_response :success
  end

  test "should update plentry" do
    put :update, :id => plentries(:one).id, :plentry => { }
    assert_redirected_to plentry_path(assigns(:plentry))
  end

  test "should destroy plentry" do
    assert_difference('Plentry.count', -1) do
      delete :destroy, :id => plentries(:one).id
    end

    assert_redirected_to plentries_path
  end
end
