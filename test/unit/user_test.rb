require 'test_helper'

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
  
  def test_that_first_user_created_becomes_admin_and_others_dont
    User.delete_all
    u1 = User.make
    u2 = User.make
    assert_equal true, u1.admin?
    assert_equal false, u2.admin?
  end
  
  def test_blog_authors
    users(:trevor).articles.create(:title => 'test', :body => 'test')
    authors = User.blog_authors
    assert_equal true, authors.include?(users(:trevor))
  end
    
  test "should select avatar and clear old avatar if exists" do
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
  
  test "should not select avatar if already in use" do
    u1 = User.make
    a1 = Avatar.make
    u1.select_avatar(a1)
    u2 = User.make
    u2.select_avatar(a1)
    u1.reload
    u2.reload
    a1.reload
    assert_nil u2.current_avatar
    assert_equal u1, a1.current_avatar_user
    assert_equal a1, u1.current_avatar
  end
  
  test "should clear user's current avatar" do
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
    
  test "should nullify current_avatar_user attribute of avatar if user is destroyed" do
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
  
  test "to_s returns login" do
    r = User.make
    assert_equal r.login, r.to_s
  end
  
  test "to_param returns id-to_s returns id-to_s" do
    r = User.make
    assert_equal "#{r.id}-#{r.to_s.parameterize}", r.to_param
  end
  
end
