require File.dirname(__FILE__) + '/../test_helper'

class ForumTest < Test::Unit::TestCase
  fixtures :all
  
  def test_to_s
    f = Forum.find(1)
    assert_equal f.to_s, 'test forum'
  end  

end
