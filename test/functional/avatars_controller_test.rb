require 'test_helper'

class AvatarsControllerTest < ActionController::TestCase
  
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
  
  def test_should_not_get_new_if_not_logged_in
    get :new
    assert_redirected_to login_path
  end
  
  def test_should_create_avatar
  end
    
  def test_should_not_get_edit_if_not_authorized
    login_as :Timothy
    get :edit, :id => 1
    assert_redirected_to root_path
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
    delete :destroy, :id => avatars(:test).id
    assert_equal old_count, Avatar.count
    assert_redirected_to root_path
  end
    
  def test_should_clear_user_using_avatar_if_avatar_destroyed
    login_as :Administrator
    assert_equal avatars(:test).current_user_id, users(:trevor).id
    delete :destroy, :id => avatars(:test)
    users(:trevor).reload
    assert_nil users(:trevor).avatar
  end
    
  # def test_should_select_avatar
  #   login_as :Timothy
  #   post :select, :id => avatars(:calvin).id
  #   users(:Timothy).reload
  #   assert_equal users(:Timothy).avatar, avatars(:calvin).public_filename
  #   avatars(:calvin).reload
  #   assert_equal users(:Timothy).id, avatars(:calvin).current_user_id
  # end
  
  # def test_should_deselect_avatar
  #   login_as :Timothy
  #   post :select, :id => avatars(:calvin).id
  #   users(:Timothy).reload
  #   assert_equal users(:Timothy).avatar, avatars(:calvin).public_filename
  #   post :deselect, :id => avatars(:calvin).id
  #   users(:Timothy).reload
  #   assert_nil users(:Timothy).avatar
  #   avatars(:calvin).reload
  #   assert_nil avatars(:calvin).current_user_id
  # end

  # def test_should_not_deselect_avatar_if_not_current_avatar_user
  # end
end
