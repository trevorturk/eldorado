require 'test_helper'

class AvatarTest < ActiveSupport::TestCase
  
  test "make makes a valid record" do
    r = Avatar.make
    assert r.valid?
  end
  
  test "to_s returns attachment_file_name" do
    r = Avatar.make
    assert_equal r.attachment_file_name, r.to_s
  end
  
  test "to_param returns id-to_s" do
    r = Avatar.make
    assert_equal "#{r.id}-#{r.to_s.parameterize}", r.to_param
  end
  
  test "attachment_file_name is unique" do
    r1 = Avatar.make
    r2 = Avatar.create { |r| r.attachment_file_name = r1.attachment_file_name }
    assert r2.errors.on(:attachment_file_name)
  end
    
  test "belongs_to user" do
    u = User.make
    r = Avatar.make(:user => u)
    assert r.user, u
  end
  
  test "validates presence of user_id" do
    r = Avatar.create { |r| r.user = nil }
    assert r.errors.on(:user_id)
  end
  
  test "belongs_to current_avatar_user" do
    u = User.make
    r = Avatar.make
    u.select_avatar(r)
    r.reload
    assert_equal u, r.current_avatar_user
  end
    
  test "should nullify avatar attribute and current_avatar relationship of user after avatar is destroyed" do
    u = User.make
    a = Avatar.make
    u.select_avatar(a)
    assert_equal u, a.current_avatar_user
    a.destroy
    u.reload
    assert_nil u.avatar
    assert_nil u.current_avatar
  end
  
end
