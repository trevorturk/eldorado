require File.dirname(__FILE__) + '/../test_helper'
require 'headers_controller'

# Re-raise errors caught by the controller.
class HeadersController; def rescue_action(e) raise e end; end

class HeadersControllerTest < Test::Unit::TestCase
  fixtures :headers

  def setup
    @controller = HeadersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:headers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_header
    old_count = Header.count
    post :create, :header => { }
    assert_equal old_count+1, Header.count
    
    assert_redirected_to header_path(assigns(:header))
  end

  def test_should_show_header
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_header
    put :update, :id => 1, :header => { }
    assert_redirected_to header_path(assigns(:header))
  end
  
  def test_should_destroy_header
    old_count = Header.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Header.count
    
    assert_redirected_to headers_path
  end
end
