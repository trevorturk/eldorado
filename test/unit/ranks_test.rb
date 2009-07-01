require 'test_helper'

class RanksTest < ActiveSupport::TestCase
  fixtures :all
  
  def test_to_s
    r = Rank.find(1)
    assert_equal r.to_s, 'no_posts'
  end
    
end
