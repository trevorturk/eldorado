require File.dirname(__FILE__) + '/../test_helper'
require 'bans_controller'

# Re-raise errors caught by the controller.
class BansController; def rescue_action(e) raise e end; end

class BansControllerTest < Test::Unit::TestCase
  all_fixtures

  def setup
    @controller = BansController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
  end

  def test_should_get_new
  end
  
  def test_should_create_ban
  end

  def test_should_show_ban
  end

  def test_should_get_edit
  end
  
  def test_should_update_ban
  end
  
  def test_should_destroy_ban
  end
  
end
