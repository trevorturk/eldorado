require File.dirname(__FILE__) + '/../test_helper'

class TopicTest < Test::Unit::TestCase
  all_fixtures
  
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def cannot_view_private_topic_unless_logged_in
  end
  
end
