require 'test_helper'

class UploadsControllerTest < ActionController::TestCase

  test "should get index (if not logged in or not)" do
    get :index
    assert_response :success
    login!
    get :index
    assert_response :success
  end
  
  test "should get new if logged in" do
    login!
    get :new
    assert_response :success
  end
  
  test "should not get new if not logged in" do
    get :new
    assert_redirected_to login_path
  end
  
  test "should create upload if logged in" do
    login!
    assert_difference 'Upload.count' do
      post :create, :upload => { :attachment => fixture_file_upload('files/rails.png', 'image/png') }
    end
    assert_redirected_to files_path
  end
  
  test "should not create upload if not logged in" do
    assert_no_difference 'Upload.count' do
      post :create, :upload => { :attachment => fixture_file_upload("files/rails.png", 'image/png') }
    end
    assert_redirected_to login_path
  end
  
  test "should create upload via (stubbed out) url" do
    Upload.any_instance.expects(:do_download_remote_file).returns(File.open("#{Rails.root}/test/fixtures/files/rails.png"))
    login!
    assert_difference 'Upload.count' do
      post :create, :upload => { :attachment_url => 'rails.png' }
    end
    assert_redirected_to files_path
  end
  
  test "should not bomb on upload via bogus (stubbed out) url" do
    Upload.any_instance.expects(:do_download_remote_file).returns(nil)
    login!
    assert_no_difference 'Upload.count' do
      post :create, :upload => { :attachment_url => 'invalid' }
    end
    assert_response :success
  end
  
  test "show redirects to root if logged in" do
    login!
    get :show, :id => Upload.make.id
    assert_redirected_to root_path
  end
  
  test "show redirects to root if not logged in" do
    get :show, :id => Upload.make.id
    assert_redirected_to root_path
  end
  
  test "edit redirects to root if logged in" do
    login!
    get :edit, :id => Upload.make.id
    assert_redirected_to root_path
  end
  
  test "edit redirects to root if not logged in" do
    get :edit, :id => Upload.make.id
    assert_redirected_to root_path
  end
  
  test "update redirects to root if logged in" do
    login!
    put :update, :id => Upload.make.id
    assert_redirected_to root_path
  end
  
  test "update redirects to root if not logged in" do
    put :update, :id => Upload.make.id
    assert_redirected_to root_path
  end
  
  test "should destroy upload if creator" do
    u = login!
    r = Upload.make(:user => u)
    assert_difference 'Upload.count', -1 do
      delete :destroy, :id => r.id
    end
    assert_redirected_to files_path
  end
  
  test "should destroy upload if admin" do
    login!(:admin => true)
    r = Upload.make
    assert_difference 'Upload.count', -1 do
      delete :destroy, :id => r.id
    end
    assert_redirected_to files_path
  end
  
  test "should not destroy upload if not creator or admin" do  
    login!
    r = Upload.make
    assert_no_difference 'Upload.count' do
      delete :destroy, :id => r.id
    end
    assert_redirected_to root_path
  end
    
end
