require File.dirname(__FILE__) + '/../test_helper'

class AvatarTest < Test::Unit::TestCase
  fixtures :all
  
  def test_to_s
    a = Avatar.find(1)
    assert_equal a.to_s, 'calvin.png'
  end
  
end
