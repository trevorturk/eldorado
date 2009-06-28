require File.dirname(__FILE__) + '/../test_helper'

class UploadsControllerTest < ActionController::TestCase
  
  # ===
  # NOTE these are real remote requests that can be run with "rake test:remote" - they won't be run with autotest
  # ===
    
  test "should create upload via (real) url" do
    login!
    assert_difference 'Upload.count' do
      post :create, :upload => { :attachment_url => 'http://www.google.com/intl/en_ALL/images/logo.gif' }
    end
    assert_redirected_to files_path
  end
  
  test "should not bomb on upload via bogus (real) url" do
    login!
    assert_no_difference 'Upload.count' do
      post :create, :upload => { :attachment_url => 'invalid' }
    end
    assert_response :success
  end
      
end
