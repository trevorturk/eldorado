require File.dirname(__FILE__) + '/../test_helper'

class PhotoTest < ActiveSupport::TestCase

  # ===
  # NOTE these are real remote requests that can be run with "rake test:remote" - they won't be run with autotest
  # ===
    
  test "should create an upload via (real) url" do
    u = Upload.create!(:attachment_url => 'http://www.google.com/intl/en_ALL/images/logo.gif') { |u| u.user = User.make }
    assert_equal 'http://www.google.com/intl/en_ALL/images/logo.gif', u.attachment_remote_url # check for correct original attachment_url value
    assert_equal 'image/gif', u.attachment_content_type # check for correct type
    assert_equal 8558, u.attachment_file_size # check for correct file size
  end
  
  test "should require upload provided via (real) url to be valid" do
    assert_no_difference 'Upload.count' do
      u = Upload.create(:attachment_url => 'invalid') { |u| u.user = User.make }
      assert u.errors.on(:attachment_file_name)
    end
  end
  
end
