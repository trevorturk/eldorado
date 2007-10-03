require File.dirname(__FILE__) + '/../test_helper'

class TopicTest < Test::Unit::TestCase
  fixtures :all
  
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_last_page
    topic = topics(:Testing)
    assert_equal topic.last_page, 1
    topic.posts_count = 30
    assert_equal topic.last_page, 1
    topic.posts_count = 31
    assert_equal topic.last_page, 2
  end
  
end
