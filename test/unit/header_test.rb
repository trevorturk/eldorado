require 'test_helper'

class HeaderTest < ActiveSupport::TestCase
  
  test "make makes a valid record" do
    r = Header.make
    assert r.valid?
  end
  
  test "to_s returns attachment_file_name" do
    r = Header.make
    assert_equal r.attachment_file_name, r.to_s
  end
  
  test "to_param returns id-to_s" do
    r = Header.make
    assert_equal "#{r.id}-#{r.to_s.parameterize}", r.to_param
  end
  
  test "attachment_file_name is unique" do
    r1 = Header.make
    r2 = Header.create { |r| r.attachment_file_name = r1.attachment_file_name }
    assert r2.errors.on(:attachment_file_name)
  end
    
  test "belongs_to user" do
    u = User.make
    r = Header.make(:user => u)
    assert r.user, u
  end
  
  test "validates presence of user_id" do
    r = Header.create { |r| r.user = nil }
    assert r.errors.on(:user_id)
  end
  
  test "random" do
    r1 = Header.make
    r2 = Header.make
    random = Header.random
    assert (random == r1) || (random == r2)
  end
  
  test "vote_up/vote_down" do
    r = Header.make
    assert_equal 0, r.votes
    r.vote_up
    r.reload
    assert_equal 1, r.votes
    r.vote_down
    r.reload
    assert_equal 0, r.votes
  end
      
end
