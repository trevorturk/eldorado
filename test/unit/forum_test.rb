require File.dirname(__FILE__) + '/../test_helper'

class ForumTest < Test::Unit::TestCase
  fixtures :forums

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_to_s
    f = Forum.find(1)
    assert_equal f.to_s, 'MyString'
  end  

end
