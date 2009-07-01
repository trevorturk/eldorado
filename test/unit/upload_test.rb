require 'test_helper'

class UploadTest < ActiveSupport::TestCase
  
  test "make makes a valid record" do
    r = Upload.make
    assert r.valid?
  end
  
  test "to_s returns attachment_file_name" do
    r = Upload.make
    assert_equal r.attachment_file_name, r.to_s
  end
  
  test "to_param returns id-to_s" do
    r = Upload.make
    assert_equal "#{r.id}-#{r.to_s.parameterize}", r.to_param
  end
  
  test "attachment_file_name is unique" do
    r1 = Upload.make
    r2 = Upload.create { |r| r.attachment_file_name = r1.attachment_file_name }
    assert r2.errors.on(:attachment_file_name)
  end
    
  test "is_mp3? returns true for audio/mpeg audio/mpg" do
    r1 = Upload.make
    assert_equal false, r1.is_mp3?
    r2 = Upload.make(:attachment_content_type => 'audio/mpeg')
    assert_equal true, r2.is_mp3?
    r3 = Upload.make(:attachment_content_type => 'audio/mpg')
    assert_equal true, r3.is_mp3?
  end
  
  test "belongs_to user" do
    u = User.make
    r = Upload.make(:user => u)
    assert r.user, u
  end
  
  test "validates presence of user_id" do
    r = Upload.create { |r| r.user = nil }
    assert r.errors.on(:user_id)
  end
  
  test "should create an upload via (stubbed out) url" do
    Upload.any_instance.expects(:do_download_remote_file).returns(File.open("#{Rails.root}/test/fixtures/files/rails.png"))
    r = Upload.create!(:attachment => nil, :attachment_url => 'rails.png') { |r| r.user = User.make }
    assert_equal 'rails.png', r.attachment_remote_url # check for correct original attachment_url value
    assert_equal 'image/png', r.attachment_content_type # check for correct type
    assert_equal 1787, r.attachment_file_size # check for correct file size
  end
  
  test "should require upload provided via (stubbed out) url to be valid" do
    Upload.any_instance.expects(:do_download_remote_file).returns(nil)
    assert_no_difference 'Upload.count' do
      r = Upload.create(:attachment => nil, :attachment_url => 'invalid') { |r| r.user = User.make }
      assert r.errors.on(:attachment_file_name)
    end
  end
    
end
