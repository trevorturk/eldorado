require File.dirname(__FILE__) + '/../test_helper'

class EventTest < Test::Unit::TestCase
  fixtures :all
  
  def test_to_s
    e = Event.find(1)
    assert_equal e.to_s, 'MyString'
  end
  
end
