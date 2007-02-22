require File.dirname(__FILE__) + '/../test_helper'
require 'ranks_controller'

# Re-raise errors caught by the controller.
class RanksController; def rescue_action(e) raise e end; end

class RanksControllerTest < Test::Unit::TestCase
  all_fixtures
  
  def setup
    @controller = RanksController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
