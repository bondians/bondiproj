require 'test_helper'

class SongtypesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:songtypes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create songtype" do
    assert_difference('Songtype.count') do
      post :create, :songtype => { }
    end

    assert_redirected_to songtype_path(assigns(:songtype))
  end

  test "should show songtype" do
    get :show, :id => songtypes(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => songtypes(:one).id
    assert_response :success
  end

  test "should update songtype" do
    put :update, :id => songtypes(:one).id, :songtype => { }
    assert_redirected_to songtype_path(assigns(:songtype))
  end

  test "should destroy songtype" do
    assert_difference('Songtype.count', -1) do
      delete :destroy, :id => songtypes(:one).id
    end

    assert_redirected_to songtypes_path
  end
end
