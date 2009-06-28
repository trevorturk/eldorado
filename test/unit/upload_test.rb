require 'test_helper'

class UploadTest < ActiveSupport::TestCase
    
  test "make makes a valid record" do
    u = Upload.make
    assert u.valid?
  end
  
  test "to_s returns attachment_file_name" do
    u = Upload.make
    assert_equal u.attachment_file_name, u.to_s
  end
  
  test "to_param" do
    u = Upload.make
    assert_equal "#{u.id}-#{u.to_s.parameterize}", u.to_param
  end
  
  test "attachment_file_name is unique" do
    u1 = Upload.make
    u2 = Upload.create { |u| u.attachment_file_name = u1.attachment_file_name }
    assert u2.errors.on(:attachment_file_name)
  end
    
  test "is_mp3? returns true for audio/mpeg audio/mpg" do
    u1 = Upload.make
    assert_equal false, u1.is_mp3?
    u2 = Upload.make(:attachment_content_type => 'audio/mpeg')
    assert_equal true, u2.is_mp3?
    u3 = Upload.make(:attachment_content_type => 'audio/mpg')
    assert_equal true, u3.is_mp3?
  end
  
  test "belongs_to user" do
    user = User.make
    upload = Upload.make(:user => user)
    assert upload.user, user
  end
  
  test "validates presence of user_id" do
    u = Upload.create { |u| u.user = nil }
    assert u.errors.on(:user_id)
  end
  
  test "should create an upload via (stubbed out) url" do
    Upload.any_instance.expects(:do_download_remote_file).returns(File.open("#{Rails.root}/test/fixtures/files/rails.png"))
    u = Upload.create!(:attachment => nil, :attachment_url => 'rails.png') { |u| u.user = User.make }
    assert_equal 'rails.png', u.attachment_remote_url # check for correct original attachment_url value
    assert_equal 'image/png', u.attachment_content_type # check for correct type
    assert_equal 1787, u.attachment_file_size # check for correct file size
  end
  
  test "should require upload provided via (stubbed out) url to be valid" do
    Upload.any_instance.expects(:do_download_remote_file).returns(nil)
    assert_no_difference 'Upload.count' do
      u = Upload.create(:attachment => nil, :attachment_url => 'invalid') { |u| u.user = User.make }
      assert u.errors.on(:attachment_file_name)
    end
  end
    
end
