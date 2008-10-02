require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
  end

  def test_should_create_comment_if_logged_in
    login_as :trevor
    assert_difference('Comment.count') do
      post :create, :comment => { :resource_id => articles(:one).id, :resource_type => 'Article', :body => 'test' }
    end
    assert_redirected_to article_path(articles(:one), :anchor => "c#{assigns(:comment).id.to_s}")    
  end
  
  def test_should_not_create_comment_if_not_logged_in
    assert_no_difference('Comment.count') do
      post :create, :comment => { :resource_id => articles(:one).id, :resource_type => 'Article', :body => 'test' }
    end
    assert_redirected_to login_path
  end

  def test_should_show_comment
    get :show, :id => comments(:one).id
    assert_response :success
  end

  def test_should_get_edit_if_admin
    login_as :Administrator
    get :edit, :id => comments(:one).id
    assert_response :success
  end
  
  def test_should_get_edit_if_author
    login_as :trevor
    get :edit, :id => comments(:one).id
    assert_response :success
  end
  
  def test_should_not_get_edit_if_not_author_or_admin
    login_as :Timothy
    get :edit, :id => comments(:one).id
    assert_redirected_to root_path
  end
  
  def test_should_not_get_edit_if_not_logged_in
    get :edit, :id => comments(:one).id
    assert_redirected_to login_path
  end

  def test_should_update_comment_if_admin
    login_as :Administrator
    put :update, :id => comments(:one).id, :comment => { :body => 'updated' }
    comments(:one).reload
    assert_equal 'updated', comments(:one).body
    assert_redirected_to article_path(articles(:one), :anchor => "c#{assigns(:comment).id.to_s}")    
  end
  
  def test_should_update_comment_if_author
    login_as :trevor
    put :update, :id => comments(:one).id, :comment => { :body => 'updated' }
    comments(:one).reload
    assert_equal 'updated', comments(:one).body
    assert_redirected_to article_path(articles(:one), :anchor => "c#{assigns(:comment).id.to_s}")    
  end
  
  def test_should_not_update_comment_if_not_author_or_admin
    login_as :Timothy
    put :update, :id => comments(:one).id, :comment => { :body => 'updated' }
    assert_equal 'one', comments(:one).body
    assert_redirected_to root_path
  end
  
  def test_should_not_update_comment_if_not_logged_in
    put :update, :id => comments(:one).id, :comment => { :body => 'updated' }
    assert_equal 'one', comments(:one).body
    assert_redirected_to login_path
  end

  def test_should_destroy_comment_if_admin
    login_as :Administrator
    assert_difference('Comment.count', -1) do
      delete :destroy, :id => comments(:one).id
    end
    assert_redirected_to article_path(articles(:one), :anchor => 'comments')
  end
    
  def test_should_destroy_comment_if_author
    login_as :trevor
    assert_difference('Comment.count', -1) do
      delete :destroy, :id => comments(:one).id
    end
    assert_redirected_to article_path(articles(:one), :anchor => 'comments')
  end
  
  def test_should_not_destroy_comment_if_not_author_or_admin
    login_as :Timothy
    assert_no_difference('Comment.count') do
      delete :destroy, :id => comments(:one).id
    end
    assert_redirected_to root_path
  end
  
  def test_should_not_destroy_comment_if_not_logged_in
    assert_no_difference('Comment.count') do
      delete :destroy, :id => comments(:one).id
    end
    assert_redirected_to login_path
  end
end
