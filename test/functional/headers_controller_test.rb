require File.dirname(__FILE__) + '/../test_helper'
require 'headers_controller'

# Re-raise errors caught by the controller.
class HeadersController; def rescue_action(e) raise e end; end

class HeadersControllerTest < Test::Unit::TestCase
  all_fixtures

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
end
