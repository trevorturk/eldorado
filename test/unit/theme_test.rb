require File.dirname(__FILE__) + '/../test_helper'

class ThemeTest < Test::Unit::TestCase
  fixtures :themes

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_to_s
    t = Theme.find(1)
    assert_equal t.to_s, 'test.css'
  end

end
