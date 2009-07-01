require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  fixtures :all
  
  def test_to_s
    c = Category.find(1)
    assert_equal c.to_s, 'test category'
  end
  
end
