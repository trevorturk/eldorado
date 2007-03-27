require File.dirname(__FILE__) + '/../test_helper'
require 'forums_controller'

# Re-raise errors caught by the controller.
class ForumsController; def rescue_action(e) raise e end; end

class ForumsControllerTest < Test::Unit::TestCase
  all_fixtures

  def setup
    @controller = ForumsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
  end

  def test_should_get_new
  end
  
  def test_should_create_forum
  end

  def test_should_show_forum
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
  end
  
  def test_should_update_forum
  end
  
  def test_should_destroy_forum
  end
end
