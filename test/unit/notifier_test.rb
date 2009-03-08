require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  
  test "subscription" do
    topic = topics(:Testing)
    post = topic.posts.first
    subscribers = topic.subscribers
    @expected.subject = "New post in #{topic}"
    @expected.body    = read_fixture('subscription')
    @expected.date    = Time.now.utc
    assert_equal @expected.body, Notifier.create_subscription(subscribers, topic, post).body
  end
  
end
