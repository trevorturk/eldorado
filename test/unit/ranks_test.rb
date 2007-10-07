require File.dirname(__FILE__) + '/../test_helper'

class RanksTest < Test::Unit::TestCase
  fixtures :all
  
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_to_s
    r = Rank.find(1)
    assert_equal r.to_s, 'no_posts'
  end
    
end
