require 'test_helper'

class SubscriptionsControllerTest < ActionController::TestCase

  def setup
    @controller = SubscriptionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    login_as :trevor
    get :index
    assert_response :success
  end
  
  def test_should_toggle_subscription
    login_as :trevor
    
    topic, user = topics(:Testing), users(:trevor)
    
    get :toggle, :id => topic.to_param
    assert_response :success
    assert user.subscriptions.include?(topic)
    
    get :toggle, :id => topic.to_param
    assert_response :success
    
    assert !user.subscriptions.include?(topic)
  end
  
  def test_should_destroy_subscription
  end
end
