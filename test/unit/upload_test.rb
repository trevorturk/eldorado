require File.dirname(__FILE__) + '/../test_helper'

class UploadTest < ActiveSupport::TestCase
  fixtures :all
  
  def test_to_s
    u = Upload.find(1)
    assert_equal u.to_s, 'MyString.png'
  end
  
end
