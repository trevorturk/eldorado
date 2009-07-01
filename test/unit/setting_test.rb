require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  fixtures :all
  
  test "current_theme is selected theme" do
    assert_nil Setting.current_theme
    r = Theme.make
    r.select
    assert_equal r, Setting.current_theme
    r.deselect
    assert_nil Setting.current_theme
  end
  
  def test_to_s
    o = Setting.find(1)
    assert_equal o.to_s, 'El Dorado'
  end
  
end
