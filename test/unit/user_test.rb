require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :all
  
  test "make creates valid record" do
    u = User.make
    assert u.valid?
  end
  
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
  
  test "avatar.current_user_avatar; user.current_avatar; destroying user nullifies avatar.current_avatar_user" do
    u = User.make
    a = Avatar.make
    assert_nil a.current_avatar_user
    assert_nil u.current_avatar
    u.select_avatar(a)
    a.reload
    u.reload
    assert_equal a, u.current_avatar
    assert_equal u, a.current_avatar_user
    u.destroy
    a.reload
    assert_nil a.current_avatar_user
  end
  
  test "user.select_avatar(avatar) selects given avatar, deselects old avatar if exists" do
    u = User.make
    old_avatar = Avatar.make
    new_avatar = Avatar.make
    u.select_avatar(old_avatar)
    u.reload
    old_avatar.reload
    assert_equal u, old_avatar.current_avatar_user
    assert_equal old_avatar, u.current_avatar
    u.select_avatar(new_avatar)
    u.reload
    old_avatar.reload
    new_avatar.reload
    assert_equal u, new_avatar.current_avatar_user
    assert_equal new_avatar, u.current_avatar
    assert_nil old_avatar.current_avatar_user
  end
  
  test "user.clear_avatar clears user's current avatar" do
    u = User.make
    a = Avatar.make
    u.select_avatar(a)
    u.reload
    a.reload
    assert_equal u, a.current_avatar_user
    assert_equal a, u.current_avatar
    u.clear_avatar
    u.reload
    a.reload
    assert_nil a.current_avatar_user
    assert_nil u.current_avatar
  end
  
  test "to_s returns login" do
    r = User.make
    assert_equal r.login, r.to_s
  end
  
  test "to_param returns id-to_s returns id-to_s" do
    r = User.make
    assert_equal "#{r.id}-#{r.to_s.parameterize}", r.to_param
  end
  
end
