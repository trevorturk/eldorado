require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  test "welcome" do
    @expected.subject = 'Notifier#welcome'
    @expected.body    = read_fixture('welcome')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifier.create_welcome(@expected.date).encoded
  end

  test "forgot_password" do
    @expected.subject = 'Notifier#forgot_password'
    @expected.body    = read_fixture('forgot_password')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifier.create_forgot_password(@expected.date).encoded
  end

  test "personal_message" do
    @expected.subject = 'Notifier#personal_message'
    @expected.body    = read_fixture('personal_message')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifier.create_personal_message(@expected.date).encoded
  end

  test "subscription" do
    topic = topics(:Testing)
    post = topic.posts.first
    
    @expected.subject = "New post in #{topic}"
    @expected.body    = read_fixture('subscription')
    @expected.date    = Time.now
    
    assert_equal @expected.body, Notifier.create_subscription(topic, post).body

  end

end
