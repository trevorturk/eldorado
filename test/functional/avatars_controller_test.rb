require File.dirname(__FILE__) + '/../test_helper'
require 'avatars_controller'

# Re-raise errors caught by the controller.
class AvatarsController; def rescue_action(e) raise e end; end

class AvatarsControllerTest < Test::Unit::TestCase
  all_fixtures

  def setup
    @controller = AvatarsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:avatars)
  end

  def test_should_get_new
    login_as :trevor
    get :new
    assert_response :success
  end
  
  def test_should_create_avatar
  end
    
  def test_should_destroy_avatar_if_user_created_avatar
    login_as :trevor
    old_count = Avatar.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Avatar.count
    assert_redirected_to avatars_path
  end
  
  def test_should_destroy_avatar_if_admin
    login_as :Administrator
    old_count = Avatar.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Avatar.count
    assert_redirected_to avatars_path
  end
  
  def test_should_not_destroy_avatar_if_not_logged_in
    old_count = Avatar.count
    delete :destroy, :id => 1
    assert_equal old_count, Avatar.count
    assert_redirected_to login_path
  end
  
  def test_should_not_destroy_avatar_if_not_authorized
    login_as :Timothy
    old_count = Avatar.count
    delete :destroy, :id => 1
    assert_equal old_count, Avatar.count
    assert_redirected_to home_path
  end
    
  def test_should_set_clear_users_using_avatar_if_avatar_destroyed
  end
  
  def test_should_select_avatar
    login_as :Timothy
    post :select, :id => avatars(:calvin).id
    users(:Timothy).reload
    assert_equal users(:Timothy).avatar, avatars(:calvin).public_filename
  end
  
end
