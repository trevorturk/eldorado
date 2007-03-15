require File.dirname(__FILE__) + '/../test_helper'
require 'files_controller'

# Re-raise errors caught by the controller.
class FilesController; def rescue_action(e) raise e end; end

class FilesControllerTest < Test::Unit::TestCase
  fixtures :files

  def setup
    @controller = FilesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:files)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_files
    old_count = Files.count
    post :create, :files => { }
    assert_equal old_count+1, Files.count
    
    assert_redirected_to files_path(assigns(:files))
  end

  def test_should_show_files
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_files
    put :update, :id => 1, :files => { }
    assert_redirected_to files_path(assigns(:files))
  end
  
  def test_should_destroy_files
    old_count = Files.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Files.count
    
    assert_redirected_to files_path
  end
end
