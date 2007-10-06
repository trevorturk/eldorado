require File.dirname(__FILE__) + '/../test_helper'

class SubscriptionTest < Test::Unit::TestCase
  fixtures :subscriptions

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_to_s
    s = Subscription.find(1)
    assert_equal s.to_s, '1'
  end
  
end
