require File.dirname(__FILE__) + '/../test_helper'
require 'subscriptions_controller'

# Re-raise errors caught by the controller.
class SubscriptionsController; def rescue_action(e) raise e end; end

class SubscriptionsControllerTest < Test::Unit::TestCase
  fixtures :all

  def setup
    @controller = SubscriptionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
  end

  def test_should_get_new
  end
  
  def test_should_create_subscription
  end

  def test_should_show_subscription
  end

  def test_should_get_edit
  end
  
  def test_should_update_subscription
  end
  
  def test_should_destroy_subscription
  end
end
