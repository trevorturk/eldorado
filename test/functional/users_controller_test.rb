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
    assert_not_nil assigns(:user)
  end

  def test_new
    get :new
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:user)
  end
  
  def test_should_not_be_able_to_edit_wrong_user
    login_as :trevor
    get :edit, :id => 2
    assert_redirected_to root_path
  end
  
  def test_should_be_able_to_edit_self
    login_as :trevor
    get :edit, :id => 4
    assert_response :success
    assert_template 'edit'
    assert_not_nil assigns(:user)
  end
  
  def test_should_update_user_if_admin
    login_as :Administrator
    put :update, :id => 4, :user => { :bio => "ok!" }
    assert_redirected_to user_path(assigns(:user))
    assert_equal "ok!", users(:trevor).bio
  end
  
  def test_should_update_user_if_self
  end
  
  def test_should_not_update_user_if_not_authorized
    login_as :trevor
    put :update, :id => 2, :user => { :bio => "ok!" }
    assert_redirected_to root_path
    assert_equal "admin", users(:Administrator).bio
  end
    
  def test_should_be_able_to_edit_any_user_if_admin
    login_as :Administrator
    get :edit, :id => 3
    assert_response :success
    assert_template 'edit'
    assert_not_nil assigns(:user)
  end

  def test_create
    num_users = User.count
    post :create, :user => {:login => 'skdj', :email => 'test@test.com', :password => 'dfj', :password_confirmation => 'dfj'}
    assert_redirected_to root_path
    assert_equal num_users + 1, User.count
  end

  def test_should_not_create_user_without_login
    num_users = User.count
    post :create, :user => {:login => '', :email => 'test@test.com', :password => 'test'}
    assert_template "new" 
    assert_equal num_users, User.count
  end
  
  def test_should_not_create_user_without_email
    num_users = User.count
    post :create, :user => {:login => 'test', :email => '', :password => 'test'}
    assert_template "new" 
    assert_equal num_users, User.count
  end

  def test_should_not_create_user_without_password_confirmation
    num_users = User.count
    post :create, :user => {:login => 'skdj', :email => 'test@test.com', :password => 'dfj', :password_confirmation => ''}
    assert_template "new" 
    assert_equal num_users, User.count
  end
  
  def test_bad_login_fails
    post :login, :user => {:login => 'skdj', :password => 'dfj'}
    assert_template "login" 
    assert_equal "Invalid user/password combination", flash[:notice]
  end
  
  def test_good_login_works
    post :login, :user => {:login => 'trevor', :password => 'test'}
    assert_equal 4, session[:user_id]
    assert_redirected_to root_path
  end

  def test_good_login_sets_auth_token
    post :login, :user => {:login => 'trevor', :password => 'test'}
    users(:trevor).reload
    assert cookies['auth_token']
    assert_equal("#{users(:trevor).auth_token}", cookies['auth_token'].first)
    assert_not_nil users(:trevor).auth_token
    assert_not_nil users(:trevor).auth_token_exp
  end
  
  def test_bad_login_does_not_set_auth_token
    post :login, :user => {:login => 'trevor', :password => 'bad'}
    users(:trevor).reload
    assert_nil cookies['auth_token']
    assert_nil users(:trevor).auth_token
    assert_nil users(:trevor).auth_token_exp
  end
  
  def test_good_auth_token_login
    @request.cookies["auth_token"] = CGI::Cookie.new("auth_token", "244cd62e5130681b86c01f8de9e9762d9a3f3645")    
    assert @request.cookies["auth_token"]
    assert_not_nil users(:Timothy).auth_token_exp
    get :index
    assert_equal 3, session[:user_id]
  end
 
  def test_expired_auth_token_login
    @request.cookies["auth_token"] = CGI::Cookie.new("auth_token", "153c53039f6e8e8ca832d1512702f412298ec3a9")    
    assert @request.cookies["auth_token"]
    assert_not_nil users(:Administrator).auth_token_exp
    get :index
    assert_nil session[:user_id]
  end
  
  def test_current_user_stays_the_same_when_new_user_created
  end
  
  def test_should_not_allow_banned_user_to_login
    # post :login, :user => {:login => 'banned', :password => 'test'}
    # assert_redirected_to logout_path
    # assert_nil session[:user_id]
  end
  
  def test_should_show_user_as_online_if_online_at_within_last_5_minutes
  end
  
end
