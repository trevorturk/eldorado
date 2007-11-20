require File.dirname(__FILE__) + '/../test_helper'

class SettingTest < Test::Unit::TestCase
  fixtures :all

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_to_s
    o = Setting.find(1)
    assert_equal o.to_s, 'El Dorado.org'
  end
  
end
