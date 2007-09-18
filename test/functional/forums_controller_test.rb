require File.dirname(__FILE__) + '/../test_helper'
require 'forums_controller'

# Re-raise errors caught by the controller.
class ForumsController; def rescue_action(e) raise e end; end

class ForumsControllerTest < Test::Unit::TestCase
  all_fixtures

  def setup
    @controller = ForumsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    login_as :Administrator
    get :index
    assert_response :success
  end

  def test_should_get_index_if_brand_new_forum_is_on_there
    login_as :Administrator
    old_count = Forum.count
    post :create, :forum => { :name => "this-is-a-test", :category_id => 1 }
    assert_equal old_count+1, Forum.count
    get :index
    assert_response :success
  end
  
  def test_should_get_new
    # on consolidated admin page
    get :new
    assert_redirected_to home_path
    login_as :Administrator
    get :new
    assert_redirected_to home_path
  end

  def test_should_get_admin
    get :admin
    assert_redirected_to home_path
    login_as :Administrator
    get :admin
    assert_redirected_to home_path
  end
  
  def test_should_create_forum
    login_as :Administrator
    old_count = Forum.count
    post :create, :forum => { :name => "this-is-a-test", :category_id => 1 }
    assert_equal old_count+1, Forum.count
  end

  def test_should_show_forum
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    # not implemented yet
    get :new
    assert_redirected_to home_path
    login_as :Administrator
    get :new
    assert_redirected_to home_path
  end
  
  def test_should_update_forum
    # not implemented yet
    get :new
    assert_redirected_to home_path
    login_as :Administrator
    get :new
    assert_redirected_to home_path
  end
  
  def test_should_destroy_forum
    # not implemented yet
    get :new
    assert_redirected_to home_path
    login_as :Administrator
    get :new
    assert_redirected_to home_path
  end
end
