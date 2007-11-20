require File.dirname(__FILE__) + '/../test_helper'

class CategoryTest < Test::Unit::TestCase
  fixtures :all

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_to_s
    c = Category.find(1)
    assert_equal c.to_s, 'test category'
  end
  
end
