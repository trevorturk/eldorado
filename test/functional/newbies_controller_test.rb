require File.dirname(__FILE__) + '/../test_helper'
require 'newbies_controller'

# Re-raise errors caught by the controller.
class NewbiesController; def rescue_action(e) raise e end; end

class NewbiesControllerTest < Test::Unit::TestCase
  def setup
    @controller = NewbiesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def only_admin_can_create_newbie
  end
  
  def only_admin_can_destroy_newbie
  end
    
end
