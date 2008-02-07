require File.dirname(__FILE__) + '/../test_helper'

class HeaderTest < Test::Unit::TestCase
  fixtures :all
  
  def test_to_s
    h = Header.find(1)
    assert_equal h.to_s, 'MyString1.png'
  end
  
  def test_random_header_or_current_header
  end

end
