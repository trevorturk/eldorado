require File.dirname(__FILE__) + '/../test_helper'

class TopicTest < Test::Unit::TestCase
  fixtures :all
  
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
