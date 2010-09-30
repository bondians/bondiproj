require 'test_helper'

class AbusesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:abuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create abuse" do
    assert_difference('Abuse.count') do
      post :create, :abuse => { }
    end

    assert_redirected_to abuse_path(assigns(:abuse))
  end

  test "should show abuse" do
    get :show, :id => abuses(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => abuses(:one).id
    assert_response :success
  end

  test "should update abuse" do
    put :update, :id => abuses(:one).id, :abuse => { }
    assert_redirected_to abuse_path(assigns(:abuse))
  end

  test "should destroy abuse" do
    assert_difference('Abuse.count', -1) do
      delete :destroy, :id => abuses(:one).id
    end

    assert_redirected_to abuses_path
  end
end
