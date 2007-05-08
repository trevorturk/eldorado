require File.dirname(__FILE__) + '/../test_helper'
require 'posts_controller'

# Re-raise errors caught by the controller.
class PostsController; def rescue_action(e) raise e end; end

class PostsControllerTest < Test::Unit::TestCase
  all_fixtures
  
  def setup
    @controller = PostsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_posts_cannot_be_made_unless_logged_in
    old_post_count = Post.count
    post :create, :post => { :topic_id => "1", :body => "this is a test" }
    assert_equal old_post_count, Post.count
    assert_redirected_to login_path
  end
  
  def test_posts_can_be_made_if_logged_in
    login_as :trevor
    old_post_count = Post.count
    post :create, :post => { :topic_id => "1", :body => "this is a test" }  
    assert assigns(:topic)
    assert assigns(:post)
    assert_equal old_post_count+1, Post.count
  end
  
  def test_posts_count_increments_when_post_created
    login_as :trevor
    old_post_count = Forum.find_by_id('1').posts_count
    post :create, :post => { :topic_id => "1", :body => "this is a test" }
    new_post_count = Forum.find_by_id('1').posts_count
    assert_equal old_post_count+1, new_post_count
  end
  
  def test_posts_count_decrements_when_post_destroyed
  end
  
end
