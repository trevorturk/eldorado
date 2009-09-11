require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
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
  end
  
  def test_should_not_be_able_to_edit_wrong_user
    login_as :trevor
    get :edit, :id => 2
    assert_redirected_to root_path
  end
  
  def test_should_not_be_able_to_edit_if_not_logged_in
    get :edit, :id => 2
    assert_redirected_to root_path
  end
  
  def test_should_not_be_able_to_update_if_not_logged_in
    put :update, :id => 4, :user => { :bio => "ok!" }
    assert_redirected_to root_path
    users(:trevor).reload
    assert_not_equal "ok!", users(:trevor).bio
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
    users(:trevor).reload
    assert_equal "ok!", users(:trevor).bio
  end
  
  def test_should_update_user_if_self
    login_as :trevor
    put :update, :id => 4, :user => { :bio => "ok!" }
    assert_redirected_to user_path(assigns(:user))
    users(:trevor).reload
    assert_equal "ok!", users(:trevor).bio
  end
  
  def test_should_not_be_able_to_make_self_admin_if_not_admin
    login_as :trevor
    assert_raises RuntimeError do
      put :update, :id => 4, :user => { :bio => "ok!?", :admin => true }
    end
    users(:trevor).reload
    assert_equal false, users(:trevor).admin
  end

  def test_should_not_be_able_to_make_self_admin_when_creating_account
    assert_raises RuntimeError do
      post :create, :user => { :login => "notadmin", :email => "test@aol.com", :password => 'test', :password_confirmation => 'test', :admin => true }
    end
  end
  
  def test_should_not_update_user_if_not_authorized
    login_as :trevor
    put :update, :id => 2, :user => { :bio => "ok!" }
    assert_redirected_to root_path
    users(:trevor).bio
    assert_equal "admin", users(:Administrator).bio
  end
    
  def test_should_be_able_to_edit_any_user_if_admin
    login_as :Administrator
    get :edit, :id => 3
    assert_response :success
    assert_template 'edit'
    assert_not_nil assigns(:user)
  end
  
  def test_should_not_update_user_if_no_email
    login_as :trevor
    put :update, :id => 4, :user => { :login => "won't work", :email => "" }
    assert_template 'edit'
    users(:trevor).reload
    assert_equal 'trevor', users(:trevor).login
  end
  
  def test_should_allow_user_to_change_password_password_change
    login_as :trevor
    put :update, :id => 4, :user => { :password => "ok", :password_confirmation => "ok" }
    users(:trevor).reload
    assert_equal User.encrypt('ok'), users(:trevor).password_hash
  end
  
  def test_should_enforce_password_confirmation_on_update_if_password_is_present
    login_as :trevor
    put :update, :id => 4, :user => { :password => "ok", :password_confirmation => "" }
    assert_template 'edit'
    users(:trevor).reload
    assert_equal User.encrypt('test'), users(:trevor).password_hash
  end
  
  def test_should_not_change_password_if_left_blank_in_edit_form
    login_as :trevor
    put :update, :id => 4, :user => { :bio => 'it works!', :password => "", :password_confirmation => "" }
    users(:trevor).reload
    assert_equal User.encrypt('test'), users(:trevor).password_hash
    assert_equal 'it works!', users(:trevor).bio
  end

  def test_create
    num_users = User.count
    post :create, :user => {:login => 'skdj', :email => 'test@test.com', :password => 'dfj', :password_confirmation => 'dfj'}
    assert_redirected_to root_path
    assert_equal num_users + 1, User.count
  end
  
  def test_create_redirects_to_login_if_site_private_and_not_logged_in
    private_site
    num_users = User.count
    post :create, :user => {:login => 'skdj', :email => 'test@test.com', :password => 'dfj', :password_confirmation => 'dfj'}
    assert_redirected_to login_path
    assert_equal num_users, User.count
  end
  
  def test_create_works_if_site_private_and_user_is_logged_in
    private_site
    login_as :trevor
    num_users = User.count
    post :create, :user => {:login => 'skdj', :email => 'test@test.com', :password => 'dfj', :password_confirmation => 'dfj'}
    assert_redirected_to users_path
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
  
  def test_should_not_create_user_without_valid_email
    num_users = User.count
    post :create, :user => {:login => 'test', :email => 'not_valid', :password => 'test'}
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
    assert_not_nil cookies['auth_token']
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
  
  def test_login_action_doesnt_bomb_with_bogus_params
    post :login
    assert_response :success
    assert_nil session[:user_id]
    post :login, :sdfsdf => {:sdfsdf => 'sdfsdf'}
    assert_response :success
    assert_nil session[:user_id]
  end
  
  def test_should_not_error_if_trying_to_log_in_when_logged_in_already
    login_as :trevor
    post :login, :user => {:login => 'trevor', :password => 'test'}
    assert_redirected_to root_path
  end
  
  def test_should_not_error_if_trying_to_logout_in_when_not_logged_in
    get :logout
    assert_redirected_to root_path
  end
  
  # def test_current_user_stays_the_same_when_new_user_created
  # end
  
  def test_should_not_allow_banned_user_to_login
    login_as :banned
    get :index
    assert_redirected_to logout_path
  end
  
  def test_should_show_user_as_online_if_online_at_within_last_5_minutes
  end
  
  def test_confirm_delete_page_works
    login_as :Administrator
    get :confirm_delete, :id => 1
    assert_response :success
    assert_template 'confirm_delete'
  end
  
  def test_delete_user_works_if_self
    login_as :Timothy
    old_count = User.count
    delete :destroy, :id => 3, :confirm => 1
    assert_equal old_count-1, User.count
    assert_redirected_to users_path
  end
  
  def test_delete_user_works_if_admin
    login_as :Administrator
    old_count = User.count
    delete :destroy, :id => 4, :confirm => 1
    assert_equal old_count-1, User.count
    assert_redirected_to users_path
  end
  
  def test_delete_user_does_not_work_if_not_admin_or_self
    login_as :Timothy
    old_count = User.count
    delete :destroy, :id => 2, :confirm => 1
    assert_equal old_count, User.count
    assert_redirected_to root_path
  end
  
  def test_delete_user_does_not_work_if_not_logged_in
    old_count = User.count
    delete :destroy, :id => 1, :confirm => 1
    assert_equal old_count, User.count
    assert_redirected_to root_path
  end
    
  def test_that_default_time_zone_works
    post :create, :user => {:login => 'timezone', :email => 'test@test.com', :password => 'dfj', :password_confirmation => 'dfj'}
    user = User.find_by_login('timezone')
    assert_equal user.time_zone, 'US/Central'
  end
  
  def test_that_user_gets_default_time_values
    post :create, :user => {:login => 'user1', :email => 'test1@test.com', :password => 'abc', :password_confirmation => 'abc'}
    assert_not_nil User.find_by_login('user1').online_at
    assert_not_nil User.find_by_login('user1').all_viewed_at
  end
  
  def test_that_user_gets_default_time_zone_values
    post :create, :user => {:login => 'user1', :email => 'test1@test.com', :password => 'abc', :password_confirmation => 'abc'}
    assert_equal User.find_by_login('user1').time_zone, 'US/Central'
  end
  
  def test_should_get_ban_if_admin
    login_as :Administrator
    get :ban, :id => users(:trevor).id
    assert_response :success
  end
  
  def test_should_not_get_ban_if_not_admin_or_not_logged_in
    get :ban, :id => users(:trevor).id
    assert_redirected_to root_path
    login_as :trevor
    get :ban, :id => users(:trevor).id
    assert_redirected_to root_path
  end
  
  def test_should_remove_ban_if_admin
    login_as :Administrator
    post :remove_ban, :id => users(:banned).id
    assert_redirected_to user_path(users(:banned))
    users(:banned).reload
    assert_nil users(:banned).ban_message
    assert_nil users(:banned).banned_until
  end
  
  def test_should_not_remove_ban_if_not_admin_or_not_logged_in
    post :remove_ban, :id => users(:banned).id
    assert_redirected_to root_path
    login_as :trevor
    post :remove_ban, :id => users(:banned).id
    assert_redirected_to root_path
  end
  
  def test_should_grant_admin_if_admin
    login_as :Administrator
    post :admin, :id => users(:trevor).id
    assert_redirected_to user_path(users(:trevor))
    users(:trevor).reload
    assert_equal users(:trevor).admin, true
  end
  
  def test_should_revoke_admin_if_admin
    login_as :Administrator
    post :admin, :id => users(:Administrator).id
    assert_redirected_to user_path(users(:Administrator))
    users(:Administrator).reload
    assert_equal users(:Administrator).admin, false
  end
  
  def test_should_not_toggle_admin_if_not_admin_or_not_logged_in
    post :admin, :id => users(:trevor).id
    users(:trevor).reload
    assert_equal users(:trevor).admin, false
    assert_redirected_to root_path
    login_as :trevor
    post :admin, :id => users(:trevor).id
    users(:trevor).reload
    assert_equal users(:trevor).admin, false
    assert_redirected_to root_path
  end

  def test_should_set_logged_out_to_false_when_logging_in
    login_as :trevor
    users(:trevor).reload
    assert_equal false, users(:trevor).logged_out
  end
  
  def test_should_set_logged_out_to_true_when_logging_out
    login_as :trevor
    get :logout
    users(:trevor).reload
    assert_equal true, users(:trevor).logged_out
  end
end
