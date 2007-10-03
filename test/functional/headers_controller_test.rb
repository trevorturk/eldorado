require File.dirname(__FILE__) + '/../test_helper'
require 'headers_controller'

# Re-raise errors caught by the controller.
class HeadersController; def rescue_action(e) raise e end; end

class HeadersControllerTest < Test::Unit::TestCase
  fixtures :all

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
  
  def test_should_create_header
  end

  def test_should_show_header
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
  end
  
  def test_should_update_header_if_authorized
  end
    
  def test_should_destroy_header
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
