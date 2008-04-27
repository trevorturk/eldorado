require File.dirname(__FILE__) + '/../test_helper'
require 'topics_controller'

# Re-raise errors caught by the controller.
class TopicsController; def rescue_action(e) raise e end; end

class TopicsControllerTest < Test::Unit::TestCase
  fixtures :all

  def setup
    @controller = TopicsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:topics)
  end

  def test_should_create_topic
    login_as :trevor
    old_topic_count = Topic.count
    old_post_count = Post.count
    post :create, :topic => { :title => "test topic create", :body => "this is a test for topic create", :forum_id => "1" }  
    assert assigns(:topic)
    assert assigns(:post)
    assert_equal old_topic_count+1, Topic.count
    t = Topic.find(:first, :order => 'id desc')
    assert_equal t.user_id, users(:trevor).id
    assert_equal t.title, 'test topic create'
    assert_equal t.forum_id, 1
    assert_equal old_post_count+1, Post.count
    p = Post.find(:first, :order => 'id desc')
    assert_equal p.user_id, users(:trevor).id
    assert_equal p.topic_id, t.id
    assert_equal p.body, 'this is a test for topic create'
    assert_redirected_to topic_path(assigns(:topic))
  end
  
  def test_must_be_logged_in_to_post_topic
    old_count = Topic.count
    post :create, :topic => { :title => "test", :body => "this is a test" }  
    assert_redirected_to login_path
  end

  def test_should_fail_to_get_new_if_not_logged_in
    get :new
    assert_redirected_to login_path
  end

  def test_should_get_new_if_logged_in
    login_as :trevor
    get :new
    assert_response :success
  end
  
  def test_should_show_topic
    get :show, :id => 1
    assert_response :success
  end

  def test_should_fail_to_get_edit_unless_user_created_topic
    get :edit, :id => 1
    assert_redirected_to login_path
  end
  
  def test_should_get_edit_if_user_created_topic
    login_as :trevor
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_get_edit_if_admin
    login_as :Administrator
    get :edit, :id => 1
    assert_response :success
  end
 
  def test_should_fail_to_update_topic_if_not_authorized
    put :update, :id => 1, :topic => { :title => "bogus!"}
    assert_redirected_to login_path
    assert_equal "Testing", topics(:Testing).title
  end
  
  def test_should_update_topic_if_authorized
    login_as :trevor
    put :update, :id => 1, :topic => { :title => "ok!", :body => "ok!" }
    assert_redirected_to topic_path(assigns(:topic))
    assert_equal "ok!", topics(:Testing).title
  end
  
  def test_should_fail_to_update_topic_if_wrong_user
    login_as :Timothy
    put :update, :id => 1, :topic => { :title => "bogus!" }
    assert_redirected_to root_path
    assert_equal "Testing", topics(:Testing).title
  end
  
  def test_should_update_topic_if_admin
    login_as :Administrator
    put :update, :id => 1, :topic => { :title => "admin!" }
    assert_redirected_to topic_path(assigns(:topic))
    assert_equal "admin!", topics(:Testing).title
  end

  def test_should_fail_to_destroy_topic_if_not_authorized
    old_count = Topic.count
    delete :destroy, :id => 1
    assert_equal old_count, Topic.count
    assert_redirected_to login_path
  end
  
  def test_should_destroy_topic_if_user_that_created_topic
    login_as :trevor
    old_count = Topic.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Topic.count
    assert_redirected_to topics_path
  end
  
  def test_should_fail_to_destroy_topic_if_wrong_user
    login_as :Timothy
    old_count = Topic.count
    delete :destroy, :id => 1
    assert_equal old_count, Topic.count
    assert_redirected_to root_path
  end
  
  def test_should_destroy_topic_if_admin
    login_as :Administrator
    old_count = Topic.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Topic.count
    assert_redirected_to topics_path
  end
  
  def test_should_redirect_to_topic_with_viewtopic_php_style_url_with_post_id
    get :unknown_request, :path => "viewtopic.php", :pid => "2"
    assert_redirected_to topic_path(:id => "1")
  end
  
  def test_should_redirect_to_topic_with_other_viewtopic_php_style_url_with_topic_id
    get :unknown_request, :path => "viewtopic.php", :id => "1"
    assert_redirected_to topic_path(:id => "1")
  end
  
  def test_should_redirect_to_topic_with_empty_viewtopic_php_style_url
    get :unknown_request, :path => "viewtopic.php"
    assert_redirected_to root_path
  end
  
  def test_should_redirect_to_forum_with_viewforum_php_style_url
    get :unknown_request, :path => "viewforum.php", :id => "1"
    assert_redirected_to forum_path(:id => "1")
  end
  
  def test_should_redirect_to_forum_with_empty_viewforum_php_style_url
    get :unknown_request, :path => "viewforum.php"
    assert_redirected_to root_path
  end
  
  def test_should_redirect_to_topic_with_viewtopic_php_style_url_second_version
  end
  
  def test_should_redirect_to_root_path_if_viewtopic_id_not_found
    # get :unknown_request, :path => "viewtopic.php", :id => "23823"
    # assert_redirected_to topic_path(:id => "23823")
    # assert_redirected_to root_path
  end
    
  def test_should_set_last_post_info_in_forum_and_topic_on_new_topic
  end
  
  def test_should_set_last_post_info_in_forum_and_topic_on_new_post_in_existing_topic
  end
  
  def test_should_set_last_post_info_in_forum_and_topic_if_most_recent_post_is_deleted
  end
  
  def test_should_show_topic_as_new
  end
  
  def test_should_not_show_topic_as_new
  end
  
  def test_should_redirect_to_newest_post_with_show_new_action
    login_as :post_test
    get :show_new, :id => 1
    # assert_redirected_to topic_path(:id => "1", :anchor => 'p' + posts(:one2).id.to_s)
  end
  
  def test_should_redirect_to_last_post_if_no_new_posts_with_show_new_action
    login_as :trevor
    get :show_new, :id => 1
    # assert_redirected_to topic_path(:id => "1", :anchor => 'p' + posts(:one3).id.to_s) 
  end
  
  def test_should_redirect_to_top_of_page_for_topic_with_no_anchor_if_first_post_in_thread
    login_as :trevor
    get :show_new, :id => 2
    assert_redirected_to topic_path(:id => "2") 
  end
    
  def test_should_redirect_to_same_path_when_logging_in_with_cookie
    # log in
    # delete cookie
    # use show_new action, which should use the cookie to log in and redirect to the requested url
    # get :show_new, :id => 1
    # assert_redirected_to topic_path(:id => "1", :anchor => 'p' + posts(:one3).id.to_s)
  end

  def test_should_allow_post_if_logged_in
    login_as :trevor
    get :show, :id => 1
    assert_response :success
    assert_select "span#reply"
  end
  
  def test_should_not_allow_post_if_not_logged_in
    get :show, :id => 1
    assert_response :success
    assert_select "span#reply", false
  end
  
  def test_should_not_allow_post_if_logged_in_and_locked
    login_as :Timothy
    get :show, :id => 3
    assert_response :success
    assert_select "span#reply", false
  end

  def test_should_allow_post_if_logged_in_and_locked_but_is_admin
    login_as :Administrator
    get :show, :id => 3
    assert_response :success
    assert_select "span#reply"
  end

  def test_should_allow_post_if_logged_in_and_locked_but_is_topic_creator
    login_as :trevor
    get :show, :id => 3
    assert_response :success
    assert_select "span#reply"
  end
  
  def test_should_error_on_topic_create_if_attr_accessible_is_not_set_right_in_post_model
  end
  
  def test_should_error_on_topic_create_if_attr_accessor_is_not_set_right_in_post_model
  end
  
  def test_should_be_ok_with_bogus_params_page_value
    get :show, :id => 1, :page => 'sdlkfjsdfs'
    assert_redirected_to root_path
    assert_equal "Sorry, the page number you requested was not valid.", flash[:notice]
  end
  
  def test_should_redirect_to_first_page_if_page_is_too_many
    get :show, :id => 1, :page => '2'
    assert_redirected_to topic_path(:id => 1)
  end
  
  def test_should_not_show_topic_if_private_site_and_not_logged_in
    private_site
    get :show, :id => 1
    assert_redirected_to login_path
  end
  
  def test_should_show_topic_if_private_site_and_logged_in
    private_site
    login_as :trevor
    get :show, :id => 1
    assert_response :success
  end
  
  def test_should_update_cached_fields_when_moving_topics_between_forums    
    login_as :Administrator
    assert_equal 2, topics(:moving).forum_id
    assert_equal 1, forums(:moving_from).topics_count
    assert_equal 1, forums(:moving_from).posts_count
    assert_equal 0, forums(:moving_to).topics_count
    assert_equal 0, forums(:moving_to).posts_count
    put :update, :id => 4, :topic => { :forum_id => 3 }
    topics(:moving).reload
    forums(:moving_from).reload
    forums(:moving_to).reload
    assert_redirected_to topic_path(topics(:moving))
    assert_equal 3, topics(:moving).forum_id
    assert_equal 0, forums(:moving_from).topics_count
    assert_equal 0, forums(:moving_from).posts_count
    assert_equal 1, forums(:moving_to).topics_count
    assert_equal 1, forums(:moving_to).posts_count
  end
  
  def test_should_update_cached_forum_fields_if_topic_destroyed
    login_as :Administrator
    assert_equal 1, forums(:moving_from).topics_count
    assert_equal 1, forums(:moving_from).posts_count
    delete :destroy, :id => 4
    forums(:moving_from).reload
    assert_equal 0, forums(:moving_from).topics_count
    assert_equal 0, forums(:moving_from).posts_count  
  end
  
  def test_should_allow_admin_to_create_sticky_topic
    login_as :Administrator
    post :create, :topic => { :title => "test_sticky", :body => "body", :forum_id => "1", :sticky => true }  
    assert_equal true, Topic.find_by_title('test_sticky').sticky
  end
  
  def test_should_allow_admin_to_make_topic_sticky_via_update
    login_as :Administrator
    put :update, :id => 1, :topic => { :sticky => true }
    assert_equal true, topics(:Testing).sticky
  end
  
  def test_should_not_allow_non_admin_to_create_sticky_topic
    login_as :trevor
    post :create, :topic => { :title => "test_sticky", :body => "body", :forum_id => "1", :sticky => true }  
    assert_equal false, Topic.find_by_title('test_sticky').sticky
  end
  
  def test_should_not_allow_non_admin_to_make_topic_sticky_via_update
    login_as :trevor
    put :update, :id => 1, :topic => { :sticky => true }
    assert_equal false, topics(:Testing).sticky
  end
  
end