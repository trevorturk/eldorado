require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  fixtures :all
  
  def test_should_get_all_topics
    assert = Topic.get.size == Topic.count
  end
  
  def test_should_get_all_topics_with_limit
    assert = Topic.get(100, 1).size == 1
  end
  
  def test_should_get_all_topics_with_conditions
    assert = Topic.get(100, 100, ['user_id = ?', users(:trevor).id]).size == users(:trevor).topics.count
  end
  
  def test_last_page
    topic = topics(:Testing)
    assert_equal topic.last_page, 1
    topic.posts_count = 30
    assert_equal topic.last_page, 1
    topic.posts_count = 31
    assert_equal topic.last_page, 2
  end
  
  def test_to_s
    t = Topic.find(1)
    assert_equal t.to_s, 'Testing'
  end
  
  # def test_topics_are_marked_as_new_when_they_should_be
  #   # is_new? helper
  # end
  
end
