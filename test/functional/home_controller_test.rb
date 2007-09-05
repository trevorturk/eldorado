require File.dirname(__FILE__) + '/../test_helper'
require 'home_controller'

# Re-raise errors caught by the controller.
class HomeController; def rescue_action(e) raise e end; end

class HomeControllerTest < Test::Unit::TestCase
  all_fixtures
  
  def setup
    @controller = HomeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_should_get_index
    get :index
    assert_response :success
  end
  
  def test_should_get_index_when_logged_in
    login_as :trevor
    get :index
    assert_response :success
  end
  
end
