require 'test_helper'

class ForumsControllerTest < ActionController::TestCase

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

  def test_should_get_edit_if_admin
    login_as :Administrator
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_not_get_edit_if_not_admin_or_not_logged_in
    get :edit, :id => 1
    assert_redirected_to root_path
    login_as :trevor
    get :edit, :id => 1
    assert_redirected_to root_path
  end
  
  def test_should_update_forum_if_admin
    login_as :Administrator
    put :update, :id => 1, :forum => { :name => 'update works!' }
    forums(:one).reload
    assert_redirected_to forum_path(forums(:one))
    assert_equal forums(:one).name, 'update works!'
  end
  
  def test_should_not_update_forum_if_not_admin_or_not_logged_in
    put :update, :id => 1, :forum => { :id => 1, :name => 'update works!' }
    forums(:one).reload
    assert_equal forums(:one).name, 'test forum'
    assert_redirected_to root_path
    login_as :trevor
    put :update, :id => 1, :forum => { :name => 'update works!' }
    forums(:one).reload
    assert_equal forums(:one).name, 'test forum'
    assert_redirected_to root_path
  end
  
  def test_should_destroy_forum_if_authorized_and_confirmed
    old_forum_count = Forum.count
    old_topic_count = Topic.count
    old_post_count = Post.count
    login_as :Administrator
    delete :destroy, :id => forums(:deleteme).id, :confirm => 1
    assert_equal old_forum_count-1, Forum.count
    assert_equal old_topic_count-1, Topic.count
    assert_equal old_post_count-1, Post.count
    assert_redirected_to forum_root_path
  end
  
  def test_should_not_delete_forum_if_not_confirmed
    old_forum_count = Forum.count
    login_as :Administrator
    delete :destroy, :id => forums(:deleteme).id
    assert_equal old_forum_count, Forum.count
    assert_redirected_to confirm_delete_forum_path(:id => forums(:deleteme).to_param)
  end
  
  def test_should_not_get_delete_confirmation_screen_if_not_authorized_or_not_logged_in
    old_forum_count = Forum.count
    get :confirm_delete, :id => forums(:deleteme).id
    assert_redirected_to root_path
    login_as :trevor
    get :confirm_delete, :id => forums(:deleteme).id
    assert_redirected_to root_path
  end
  
  def test_should_not_delete_forum_if_not_authorized
    old_forum_count = Forum.count
    get :confirm_delete, :id => forums(:deleteme).id
    assert_equal old_forum_count, Forum.count
    assert_redirected_to root_path
    delete :destroy, :id => forums(:deleteme).id, :confirm => 1
    assert_equal old_forum_count, Forum.count
    assert_redirected_to root_path
  end
  
  def test_should_not_delete_category_if_not_logged_in
    old_forum_count = Forum.count
    delete :destroy, :id => forums(:deleteme).id, :confirm => 1
    assert_equal old_forum_count, Forum.count
    assert_redirected_to root_path
  end
end
