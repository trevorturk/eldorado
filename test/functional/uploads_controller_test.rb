require File.dirname(__FILE__) + '/../test_helper'
require 'uploads_controller'

# Re-raise errors caught by the controller.
class UploadsController; def rescue_action(e) raise e end; end

class UploadsControllerTest < Test::Unit::TestCase
  fixtures :uploads

  def setup
    @controller = UploadsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:uploads)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_upload
    old_count = Upload.count
    post :create, :upload => { }
    assert_equal old_count+1, Upload.count
    
    assert_redirected_to upload_path(assigns(:upload))
  end

  def test_should_show_upload
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_upload
    put :update, :id => 1, :upload => { }
    assert_redirected_to upload_path(assigns(:upload))
  end
  
  def test_should_destroy_upload
    old_count = Upload.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Upload.count
    
    assert_redirected_to uploads_path
  end
end
