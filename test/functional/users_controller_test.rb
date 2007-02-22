require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase
  all_fixtures
  
  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :success
  end

  def test_show
    get :show, :id => 1
    assert_response :success
  end

  def test_new
    get :new
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:user)
  end

  def test_create
    num_users = User.count
    post :create, :user => {:login => 'skdj', :email => 'trevor@aol.com', :password => 'dfj'}
    assert_redirected_to login_path
    assert_equal num_users + 1, User.count
  end
  
  def test_bad_login_fails
    post :login, :login => 'skdj', :password => 'dfj'
    assert_template "login" 
    assert_equal "Invalid user/password combination", flash[:notice]
  end
  
  def test_good_login_works
    post :login, :login => "trevor", :password => "test" 
    assert_equal 4, session[:user_id]
    assert_redirected_to home_path
  end
  
end
