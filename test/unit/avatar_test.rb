require File.dirname(__FILE__) + '/../test_helper'

class AvatarTest < Test::Unit::TestCase
  fixtures :all

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_to_s
    a = Avatar.find(1)
    assert_equal a.to_s, 'calvin.png'
  end
  
end
