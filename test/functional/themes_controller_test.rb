require File.dirname(__FILE__) + '/../test_helper'
require 'themes_controller'

# Re-raise errors caught by the controller.
class ThemesController; def rescue_action(e) raise e end; end

class ThemesControllerTest < Test::Unit::TestCase
  fixtures :all

  def setup
    @controller = ThemesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
  end

  def test_should_get_new
  end
  
  def test_should_create_theme
  end
    
  def test_should_destroy_theme_if_authorized
  end
end
