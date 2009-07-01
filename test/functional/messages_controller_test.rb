require 'test_helper'

class MessagesControllerTest < ActionController::TestCase

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:messages)
  end
  
  def test_should_get_index_if_logged_in
    login_as :trevor
    get :index
    assert_response :success
    assert assigns(:messages)
  end
  
  def test_should_not_get_new_if_logged_in
    login_as :trevor
    get :new
    assert_redirected_to root_path
  end
  
  def test_should_not_get_new_if_not_logged_in
    get :new
    assert_redirected_to root_path
  end
  
  def test_should_create_message_if_logged_in
    login_as :trevor
    old_count = Message.count
    post :create, :message => {:body => "test" }
    assert_equal old_count+1, Message.count
    assert_response :success
  end
  
  def test_should_not_create_message_if_not_logged_in
    old_count = Message.count
    post :create, :message => {:body => "test" }
    assert_equal old_count, Message.count
    assert_redirected_to login_path
  end

  def test_should_show
    get :show, :id => messages(:one)
    assert_response :success
  end

  def test_should_not_edit_or_update_if_not_logged_in
    get :edit, :id => messages(:one)
    assert_redirected_to root_path
    put :update, :id => messages(:one), :message => {:body => "test"}
    assert_redirected_to root_path
  end
  
  def test_should_not_edit_or_update_if_user_with_no_messages
    login_as :Timothy
    get :edit, :id => messages(:one)
    assert_redirected_to root_path
    put :update, :id => messages(:one), :message => {:body => "test"}
    assert_redirected_to root_path
  end
  
  def test_should_not_edit_or_update_if_admin
    login_as :Administrator
    get :edit, :id => messages(:one)
    assert_redirected_to root_path
    put :update, :id => messages(:one), :message => {:body => "test"}
    assert_redirected_to root_path
  end
  
  def test_should_destroy_message_if_creator
    old_count = Message.count
    login_as :trevor
    delete :destroy, :id => messages(:two)
    assert_equal old_count-1, Message.count
  end
  
  def test_should_destroy_message_if_admin
    old_count = Message.count
    login_as :Administrator
    delete :destroy, :id => messages(:two)
    assert_equal old_count-1, Message.count
  end
  
  def test_should_not_destroy_message_if_not_logged_in
    old_count = Message.count
    delete :destroy, :id => messages(:one)
    assert_equal old_count, Message.count
    assert_redirected_to root_path
  end
  
  def test_should_not_destroy_message_if_not_creator
    login_as :trevor
    old_count = Message.count
    delete :destroy, :id => messages(:one)
    assert_equal old_count, Message.count
    assert_redirected_to root_path
  end
  
  def test_more_messages_path_should_work
    get :more
    assert_response :success
  end
  
  def test_refresh_messages_path_should_work_when_logged_in
    login_as :trevor
    get :refresh
    assert_response :success
  end
  
  def test_refresh_messages_path_should_work_when_not_logged_in
    get :refresh
    assert_response :success
  end
  
  def test_refresh_chatters_path_should_work_when_logged_in
    login_as :trevor
    get :refresh_chatters
    assert_response :success
  end
  
  def test_refresh_chatters_path_should_work_when_not_logged_in
    get :refresh_chatters
    assert_response :success
  end
end
