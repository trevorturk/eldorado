require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  
  def test_should_get_index
    get :index
    assert_response :success
  end
  
  def test_should_get_index_when_logged_in
    login_as :trevor
    get :index
    assert_response :success
  end
  
  def test_should_get_index_when_not_logged_in
    get :index
    assert_response :success
  end
  
  def test_should_redirect_to_login_if_site_is_private_and_not_logged_in
    private_site
    get :index
    assert_redirected_to login_path
  end
  
  def test_should_get_index_if_site_is_private_and_logged_in
    login_as :trevor
    private_site
    get :index
    assert_response :success
  end
  
  def test_should_get_help
    get :help
    assert_response :success
  end
  
  # def test_should_not_update_session_online_at
  #   # if current_user HAS been active in the last 10 minutes
  # end

  # def test_should_update_session_online_at
  #   # if current_user HASN'T been active in the last 10 minutes
  # end

  # def test_should_have_correct_online_at
  #   # if current_user just logged in, save they're online_at from the db for use in session
  # end
end
