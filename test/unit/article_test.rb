require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  
  # def test_get
  # end
  
  def test_to_s
    t = Article.first
    assert_equal t.to_s, t.title
  end
end
