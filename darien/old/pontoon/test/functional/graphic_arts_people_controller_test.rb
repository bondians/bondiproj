require 'test_helper'

class GraphicArtsPeopleControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:graphic_arts_people)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create graphic_arts_person" do
    assert_difference('GraphicArtsPerson.count') do
      post :create, :graphic_arts_person => { }
    end

    assert_redirected_to graphic_arts_person_path(assigns(:graphic_arts_person))
  end

  test "should show graphic_arts_person" do
    get :show, :id => graphic_arts_people(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => graphic_arts_people(:one).to_param
    assert_response :success
  end

  test "should update graphic_arts_person" do
    put :update, :id => graphic_arts_people(:one).to_param, :graphic_arts_person => { }
    assert_redirected_to graphic_arts_person_path(assigns(:graphic_arts_person))
  end

  test "should destroy graphic_arts_person" do
    assert_difference('GraphicArtsPerson.count', -1) do
      delete :destroy, :id => graphic_arts_people(:one).to_param
    end

    assert_redirected_to graphic_arts_people_path
  end
end
