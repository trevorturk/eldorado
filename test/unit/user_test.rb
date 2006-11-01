require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_invalid_with_empty_attributes
    user = User.new
    assert !user.valid?
    assert user.errors.invalid?(:login)
    assert user.errors.invalid?(:email)
    assert user.errors.invalid?(:password_hash)
  end
  
  def test_login_has_no_spaces
    user = User.new(:email => 'valid@email.com', :password_hash => 'notblank')
    user.login = 'x x'
    assert !user.valid?
  end

  def test_login_is_not_xss
    user = User.new(:email => 'valid@email.com', :password_hash => 'notblank')
    user.login = "<script>alert('xss')</script>"
    assert !user.valid?
  end
  
  def test_login_has_not_bad_characters
    user = User.new(:email => 'valid@email.com', :password_hash => 'notblank')
    user.login = "x--xx--x"
    assert !user.valid?
    user.login = "xxx!"
    assert !user.valid?
    user.login = "thisisthething@@"
    assert !user.valid?
    user.login = "#kjsdkjsd"
    assert !user.valid?
    user.login = "x x"
    assert !user.valid?
    user.login = "000"
    assert !user.valid?
  end
          
end
