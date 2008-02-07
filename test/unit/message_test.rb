require File.dirname(__FILE__) + '/../test_helper'

class MessageTest < ActiveSupport::TestCase
  fixtures :all
  
  def test_to_s
    m = Message.find(:first)
    assert_equal m.to_s, 'first message'
  end
  
end
