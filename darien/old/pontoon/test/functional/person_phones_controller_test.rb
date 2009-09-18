require 'test_helper'

class PersonPhonesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:person_phones)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create person_phone" do
    assert_difference('PersonPhone.count') do
      post :create, :person_phone => { }
    end

    assert_redirected_to person_phone_path(assigns(:person_phone))
  end

  test "should show person_phone" do
    get :show, :id => person_phones(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => person_phones(:one).to_param
    assert_response :success
  end

  test "should update person_phone" do
    put :update, :id => person_phones(:one).to_param, :person_phone => { }
    assert_redirected_to person_phone_path(assigns(:person_phone))
  end

  test "should destroy person_phone" do
    assert_difference('PersonPhone.count', -1) do
      delete :destroy, :id => person_phones(:one).to_param
    end

    assert_redirected_to person_phones_path
  end
end
