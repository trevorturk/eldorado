require 'test_helper'

class HeadersControllerTest < ActionController::TestCase

  def setup
    @controller = HeadersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
  end

  def test_should_get_new
    login_as :trevor
    get :new
    assert_response :success
  end
  
  # def test_should_create_header
  #   login_as :Administrator
  #   old_count = Header.count
  #   put :create, :header => {:description => "test"}
  #   assert_equal old_count+1, Header.count
  #   assert_redirected_to topic_path(assigns(:header))
  # end
  
  # def test_should_not_create_header_without_file
  # end

  def test_should_show_header
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit_or_perform_update_if_admin
    login_as :Administrator
    get :edit, :id => 1
    assert_response :success
    put :update, :id => 1, :header => {:description => "test"}
    assert_redirected_to header_path(assigns(:header))
  end
  
  def test_should_get_edit_or_perform_update_if_user_that_made_it
    login_as :trevor
    get :edit, :id => 1
    assert_response :success
    put :update, :id => 1, :header => {:description => "test"}
    assert_redirected_to header_path(assigns(:header))
  end
  
  def test_should_not_get_edit_or_perform_update_if_not_logged_in
    get :edit, :id => 1
    assert_redirected_to login_path
    put :update, :id => 1, :header => {:description => "test"}
    assert_redirected_to login_path
  end
  
  def test_should_not_get_edit_or_perform_update_if_not_authorized
    login_as :Timothy
    get :edit, :id => 1
    assert_redirected_to root_path
    put :update, :id => 1, :header => {:description => "test"}
    assert_redirected_to root_path
  end
  
  def test_should_update_header
    login_as :Administrator
    put :update, :id => 1, :header => {:description => "test"}
    assert_redirected_to header_path(assigns(:header))
  end
  
  def test_should_destroy_header_if_creator
    old_count = Header.count
    login_as :trevor
    delete :destroy, :id => 1
    assert_equal old_count-1, Header.count
    assert_redirected_to headers_path
  end
  
  def test_should_destroy_header_if_admin
    old_count = Header.count
    login_as :Administrator
    delete :destroy, :id => 1
    assert_equal old_count-1, Header.count
    assert_redirected_to headers_path
  end
  
  def test_should_not_destroy_header_if_not_authorized
    old_count = Header.count
    delete :destroy, :id => 1
    assert_equal old_count, Header.count
    assert_redirected_to login_path
    login_as :Timothy
    delete :destroy, :id => 1
    assert_equal old_count, Header.count
    assert_redirected_to login_path
  end
  
  def test_should_vote_up
    login_as :trevor
    assert_equal 0, headers(:one).votes
    post :vote_up, :id => 1
    assert_response :success
    headers(:one).reload
    assert_equal 1, headers(:one).votes
  end
  
  def test_should_vote_down
    login_as :trevor
    assert_equal 0, headers(:one).votes
    post :vote_down, :id => 1
    assert_response :success
    headers(:one).reload
    assert_equal -1, headers(:one).votes
  end
  
  def test_should_vote_up_requries_login
    post :vote_up, :id => 1
    assert_redirected_to login_path
  end 

  def test_should_vote_down_requries_login
    post :vote_down, :id => 1
    assert_redirected_to login_path
  end
end
