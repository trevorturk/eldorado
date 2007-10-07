require File.dirname(__FILE__) + '/../test_helper'

class BanTest < Test::Unit::TestCase
  fixtures :bans

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_to_s
    b = Ban.find(1)
    assert_equal b.to_s, '1'
  end
  
end
