require 'test_helper'

class SubscriptionsControllerTest < ActionController::TestCase

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
    login_as :trevor
    
    topic, user = topics(:Testing), users(:trevor)
    
    get :toggle, :id => topic.to_param
    assert_response :success
    assert user.subscriptions.include?(topic)
    
    delete :destroy, :id => Subscription.last.id
    assert_redirected_to subscriptions_path
    
    assert !user.subscriptions.include?(topic)
  end
  
  def test_should_not_bomb_if_no_subscription_found_on_destroy_subscription
    login_as :trevor    
    delete :destroy, :id => '1234567890'
    assert_redirected_to root_path
  end
  
end
