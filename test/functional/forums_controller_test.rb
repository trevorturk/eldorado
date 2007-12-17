require File.dirname(__FILE__) + '/../test_helper'
require 'forums_controller'

# Re-raise errors caught by the controller.
class ForumsController; def rescue_action(e) raise e end; end

class ForumsControllerTest < Test::Unit::TestCase
  fixtures :all

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
  
  def test_should_get_new_if_admin
    login_as :Administrator
    get :new
    assert_response :success
  end
  
  def test_should_not_get_new_if_not_admin_or_logged_in
    get :new
    assert_redirected_to root_path
    login_as :trevor
    get :new
    assert_redirected_to root_path
  end
  
  def test_should_create_forum
    login_as :Administrator
    old_count = Forum.count
    post :create, :forum => { :name => "this-is-a-test", :category_id => 1 }
    assert_equal old_count+1, Forum.count
    assert_redirected_to forum_path(Forum.find(:first, :order => 'id desc'))
  end

  def test_should_show_forum
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    # not implemented yet
    get :new
    assert_redirected_to root_path
    login_as :Administrator
    get :new
    assert_redirected_to root_path
  end
  
  def test_should_update_forum
    # not implemented yet
    get :new
    assert_redirected_to root_path
    login_as :Administrator
    get :new
    assert_redirected_to root_path
  end
  
  def test_should_destroy_forum
    # not implemented yet
    get :new
    assert_redirected_to root_path
    login_as :Administrator
    get :new
    assert_redirected_to root_path
  end
end
