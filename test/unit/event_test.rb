require 'test_helper'

class EventTest < ActiveSupport::TestCase
  fixtures :all
  
  def test_to_s
    e = Event.find(1)
    assert_equal e.to_s, 'MyString'
  end
  
end
