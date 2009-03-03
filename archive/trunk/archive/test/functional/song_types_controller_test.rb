require 'test_helper'

class SongTypesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:song_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create song_type" do
    assert_difference('SongType.count') do
      post :create, :song_type => { }
    end

    assert_redirected_to song_type_path(assigns(:song_type))
  end

  test "should show song_type" do
    get :show, :id => song_types(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => song_types(:one).id
    assert_response :success
  end

  test "should update song_type" do
    put :update, :id => song_types(:one).id, :song_type => { }
    assert_redirected_to song_type_path(assigns(:song_type))
  end

  test "should destroy song_type" do
    assert_difference('SongType.count', -1) do
      delete :destroy, :id => song_types(:one).id
    end

    assert_redirected_to song_types_path
  end
end
