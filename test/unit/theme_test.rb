require File.dirname(__FILE__) + '/../test_helper'

class ThemeTest < Test::Unit::TestCase
  fixtures :all
  
  def test_to_s
    t = Theme.find(1)
    assert_equal t.to_s, 'test.css'
  end

end
