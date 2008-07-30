require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :all
  
  def test_require_login_email_and_password
    u = User.create
    assert ! u.valid?
    u = User.create(:login => "test")
    assert ! u.valid?
    u = User.create(:login => "test", :email => "email")
    assert ! u.valid?
    u = User.create(:login => "test", :email => "email", :password => "sdlfkj", :password_confirmation => '')
    assert ! u.valid?
    u = User.create(:login => "test", :email => "email", :password => "sdlfkj", :password_confirmation => "sdlfkj")
    assert ! u.valid?
    u = User.create(:login => "test", :email => "email@address.com", :password => "sdlfkj", :password_confirmation => "sdlfkj")
    assert u.valid?
  end
  
  def test_blog_authors
    users(:trevor).articles.create(:title => 'test', :body => 'test')
    authors = User.blog_authors
    assert_equal true, authors.include?(users(:trevor))
  end
  
  def test_to_s
    u = User.find(1)
    assert_equal u.to_s, 'Guest'
  end
end
