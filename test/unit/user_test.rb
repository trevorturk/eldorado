require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def cannot_edit_user_unless_self_or_admin
  end
  
  def cannot_edit_admin_unless_also_admin
  end
                
end
