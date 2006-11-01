require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase
  fixtures :users

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :redirect
  end

  def test_list
    get :list
    assert_response :redirect
  end

  def test_show
    get :show, :id => 1
    assert_response :redirect
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:user)
  end

  def test_create
    num_users = User.count

    post :create, :user => {:login => 'skdj', :email => 'trevor@aol.com', :password_hash => 'dfj'}

    assert_response :redirect

    assert_equal num_users + 1, User.count
  end

  def test_edit
    get :edit, :id => 1
    assert_response :redirect
  end

  def test_update
    post :update, :id => 1
    session[:user_id] == 1
    assert_response :redirect
  end

end
