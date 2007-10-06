require File.dirname(__FILE__) + '/../test_helper'

class UploadTest < Test::Unit::TestCase
  fixtures :uploads

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_to_s
    u = Upload.find(1)
    assert_equal u.to_s, 'MyString.png'
  end
  
end
