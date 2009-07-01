require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase

  def test_should_not_get_index
    get :index
    assert_redirected_to forum_root_path
    login_as :Administrator
    get :index
    assert_redirected_to forum_root_path
    login_as :trevor
    get :index
    assert_redirected_to forum_root_path
  end
  
  def test_should_get_new_if_admin
    login_as :Administrator
    get :new
    assert_response :success
  end
  
  def test_should_not_get_new_if_not_admin_or_not_logged_in
    get :new
    assert_redirected_to root_path
    login_as :trevor
    get :new
    assert_redirected_to root_path
  end

  def test_should_create_category_if_admin
    login_as :Administrator
    old_count = Category.count
    post :create, :category => {:name => 'test', :position => 0}
    assert_equal old_count+1, Category.count
  end
  
  def test_should_not_create_category_if_not_admin_or_not_logged_in
    old_count = Category.count
    post :create, :category => {:name => 'test', :position => 0}
    assert_redirected_to root_path
    assert_equal old_count, Category.count
    login_as :trevor
    post :create, :category => {:name => 'test', :position => 0}
    assert_redirected_to root_path
    assert_equal old_count, Category.count
  end

  def test_should_show_category
    get :show, :id => 1
    assert_response :success
    login_as :trevor
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
  
  def test_should_update_category_if_admin
    login_as :Administrator
    put :update, :id => 1, :category => { :name => 'update works!' }
    categories(:one).reload
    assert_redirected_to category_path(categories(:one))
    assert_equal categories(:one).name, 'update works!'
  end
  
  def test_should_not_update_category_if_not_admin_or_not_logged_in
    put :update, :id => 1, :category => { :id => 1, :name => 'update works!' }
    categories(:one).reload
    assert_equal categories(:one).name, 'test category'
    assert_redirected_to root_path
    login_as :trevor
    put :update, :id => 1, :category => { :id => 1, :name => 'update works!' }
    categories(:one).reload
    assert_equal categories(:one).name, 'test category'
    assert_redirected_to root_path
  end
  
  def test_should_destroy_category_if_authorized_and_confirmed
    old_category_count = Category.count
    old_forum_count = Forum.count
    old_topic_count = Topic.count
    old_post_count = Post.count
    login_as :Administrator
    delete :destroy, :id => categories(:deleteme).id, :confirm => 1
    assert_equal old_category_count-1, Category.count
    assert_equal old_forum_count-1, Forum.count
    assert_equal old_topic_count-1, Topic.count
    assert_equal old_post_count-1, Post.count
    assert_redirected_to forum_root_path
  end
  
  def test_should_not_delete_category_if_not_confirmed
    old_category_count = Category.count
    login_as :Administrator
    delete :destroy, :id => categories(:deleteme).id
    assert_equal old_category_count, Category.count
    assert_redirected_to confirm_delete_category_path(:id => categories(:deleteme).to_param)
  end
  
  def test_should_not_get_delete_confirmation_screen_if_not_authorized_or_not_logged_in
    old_category_count = Category.count
    get :confirm_delete, :id => categories(:deleteme).id
    assert_redirected_to root_path
    login_as :trevor
    get :confirm_delete, :id => categories(:deleteme).id
    assert_redirected_to root_path
  end
  
  def test_should_not_delete_category_if_not_authorized
    old_category_count = Category.count
    get :confirm_delete, :id => categories(:deleteme).id
    assert_equal old_category_count, Category.count
    assert_redirected_to root_path
    delete :destroy, :id => categories(:deleteme).id, :confirm => 1
    assert_equal old_category_count, Category.count
    assert_redirected_to root_path
  end
  
  def test_should_not_delete_category_if_not_logged_in
    old_category_count = Category.count
    delete :destroy, :id => categories(:deleteme).id, :confirm => 1
    assert_equal old_category_count, Category.count
    assert_redirected_to root_path
  end
end
