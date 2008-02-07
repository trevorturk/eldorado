require File.dirname(__FILE__) + '/../test_helper'

class SettingTest < Test::Unit::TestCase
  fixtures :all
  
  def test_to_s
    o = Setting.find(1)
    assert_equal o.to_s, 'El Dorado'
  end
  
end
