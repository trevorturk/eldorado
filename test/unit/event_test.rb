require File.dirname(__FILE__) + '/../test_helper'

class EventTest < Test::Unit::TestCase
  fixtures :all

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_to_s
    e = Event.find(1)
    assert_equal e.to_s, 'MyString'
  end
  
end
