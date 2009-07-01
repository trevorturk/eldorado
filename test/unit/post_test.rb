require 'test_helper'

class PostTest < ActiveSupport::TestCase
  fixtures :all
  
  def test_page_value_set_properly
  end
  
  def test_should_send_subscription_email_after_create
    t = topics(:Testing)
    assert_equal t.subscribers, [users(:Guest), users(:Administrator)]
    assert_emails 1 do
      t.posts.create!(:body => 'post') {|p| p.user = users(:trevor)}
    end
  end
  
  def test_should_not_send_subscription_email_to_user_that_created_the_post
    t = topics(:Testing)
    p = t.posts.new(:body => 'post') {|p| p.user = users(:Guest)}
    assert_equal t.subscribers, [users(:Guest), users(:Administrator)]
    Mailer.expects(:deliver_subscription).with([users(:Administrator)], t, p)
    p.save!
  end
  
  def test_should_not_send_subscription_email_if_no_subscribers
    t = topics(:Private)
    assert_equal t.subscribers, []
    assert_emails 0 do
      t.posts.create!(:body => 'post') {|p| p.user = users(:trevor)}
    end
  end
  
  def test_to_s
    p = Post.find(1)
    assert_equal p.to_s, 'MyText'
  end
  
end
