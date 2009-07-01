require 'test_helper'

class ThemeTest < ActiveSupport::TestCase
  
  test "make makes a valid record" do
    r = Theme.make
    assert r.valid?
  end
  
  test "to_s returns attachment_file_name" do
    r = Theme.make
    assert_equal r.attachment_file_name, r.to_s
  end
  
  test "to_param returns id-to_s" do
    r = Theme.make
    assert_equal "#{r.id}-#{r.to_s.parameterize}", r.to_param
  end
  
  test "attachment_file_name is unique" do
    r1 = Theme.make
    r2 = Theme.create { |r| r.attachment_file_name = r1.attachment_file_name }
    assert r2.errors.on(:attachment_file_name)
  end
    
  test "belongs_to user" do
    u = User.make
    r = Theme.make(:user => u)
    assert r.user, u
  end
  
  test "validates presence of user_id" do
    r = Theme.create { |r| r.user = nil }
    assert r.errors.on(:user_id)
  end
  
  test "should select/deselect" do
    r = Theme.make
    r.select
    assert_equal r, Setting.current_theme
    r.deselect
    assert_nil Setting.current_theme
  end
   
  test "should deselect theme if destroyed" do
    r = Theme.make
    r.select
    assert_equal r, Setting.current_theme
    r.destroy
    assert_nil Setting.current_theme
  end
  
end
