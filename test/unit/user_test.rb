require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  all_fixtures
  
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
    assert u.valid?
  end
  
  def test_user_gets_default_timestamps
    u = User.create(:login => "test", :email => "email", :password => "sdlfkj", :password_confirmation => "sdlfkj")
    assert_not_nil u.last_login_at
    assert_not_nil u.profile_updated_at
    assert_equal u.last_login_at, u.profile_updated_at
  end
  
end
