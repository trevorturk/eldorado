require 'test_helper'

class AvatarsControllerTest < ActionController::TestCase
  
  test "should get index (logged in or not)" do
    get :index
    assert_response :success
    login!
    get :index
    assert_response :success
  end

  test "should get new if logged in" do
    login!
    get :new
    assert_response :success
  end
  
  test "should not get new if not logged in" do
    get :new
    assert_redirected_to login_path
  end
  
  test "should create avatar if logged in" do
    login!
    assert_difference 'Avatar.count' do
      post :create, :avatar => { :attachment => fixture_file_upload('files/rails.png', 'image/png') }
    end
    assert_redirected_to avatars_path
  end
  
  test "should not create avatar if not logged in" do
    assert_no_difference 'Avatar.count' do
      post :create, :avatar => { :attachment => fixture_file_upload('files/rails.png', 'image/png') }
    end
    assert_redirected_to login_path
  end
            
  test "should not create avatar if not an image" do
    login!
    assert_no_difference 'Avatar.count' do
      post :create, :avatar => { :attachment => fixture_file_upload('files/test.css', 'text/css') }
    end
    assert_response :success # TODO figure out how to test with unit tests instead
  end
  
  test "should not select/deselect if not logged in" do
    post :select, :id => Avatar.make.id
    assert_redirected_to login_path
    post :deselect, :id => Avatar.make.id
    assert_redirected_to login_path
  end
  
  test "should select avatar" do
    u = login!
    a = Avatar.make
    post :select, :id => a.id
    u.reload
    a.reload
    assert_equal u, a.current_avatar_user
    assert_equal a, u.current_avatar
    assert_redirected_to avatars_path
    assert_equal "Avatar selected", flash[:notice]
  end
      
  test "should not select avatar if already in use" do
    new_user = login!
    old_user = User.make
    a = Avatar.make
    old_user.select_avatar(a)
    post :select, :id => a.id
    new_user.reload
    old_user.reload
    a.reload
    assert_nil new_user.current_avatar
    assert_equal old_user, a.current_avatar_user
    assert_equal a, old_user.current_avatar
    assert_redirected_to avatars_path
    assert_equal "This avatar is already in use", flash[:notice]
  end
    
  test "should clear avatar" do
    u = login!
    a = Avatar.make
    u.select_avatar(a)
    post :deselect, :id => a.id
    u.reload
    a.reload
    assert_nil u.current_avatar
    assert_nil a.current_avatar_user
    assert_redirected_to avatars_path
    assert_equal "Avatar cleared", flash[:notice]
  end
  
  test "should not clear avatar if in use by a different user" do
    new_user = login!
    old_user = User.make
    a = Avatar.make
    old_user.select_avatar(a)
    post :deselect, :id => a.id
    new_user.reload
    old_user.reload
    a.reload
    assert_nil new_user.current_avatar
    assert_equal old_user, a.current_avatar_user
    assert_equal a, old_user.current_avatar
    assert_redirected_to avatars_path
    assert_equal "This avatar is already in use", flash[:notice]
  end
  
end
