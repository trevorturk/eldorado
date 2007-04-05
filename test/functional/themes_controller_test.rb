require File.dirname(__FILE__) + '/../test_helper'
require 'themes_controller'

# Re-raise errors caught by the controller.
class ThemesController; def rescue_action(e) raise e end; end

class ThemesControllerTest < Test::Unit::TestCase
  all_fixtures

  def setup
    @controller = ThemesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:themes)
  end

  def test_should_get_new
    login_as :trevor
    get :new
    assert_response :success
  end
  
  def test_should_create_theme
  end
    
  def test_should_destroy_theme_if_authorized
  end
end
