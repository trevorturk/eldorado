require 'test_helper'

class PostsControllerTest < ActionController::TestCase
    
  def test_index_should_work
    get :index
    assert_response :success
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
  
  def test_posts_cannot_be_blank
    login_as :trevor
    old_post_count = Post.count
    post :create, :post => { :topic_id => "1" }
    assert_equal old_post_count, Post.count
  end
  
  # def test_posts_cannot_be_made_with_bogus_topic_id
  #   login_as :trevor
  #   old_post_count = Post.count
  #   post :create, :post => { :topic_id => "13249002923" }
  #   assert_equal old_post_count, Post.count
  # end
  
  def test_post_create_redirects_to_correct_page
    login_as :trevor
    topic = Topic.find_by_id('1')
    assert_equal topic.posts_count, 3
    topic.posts_count = 29
    topic.save!
    assert_equal topic.last_page, 1
    post :create, :post => { :topic_id => "1", :body => "this is a test" }  
    topic = Topic.find_by_id('1')
    assert_equal topic.posts_count, 30
    assert_equal topic.last_page, 1
    assert_redirected_to :controller => 'topics', :action => 'show', :id => '1', :page => '1', :anchor => 'p' + Post.last.id.to_s
    post :create, :post => { :topic_id => "1", :body => "this is a test!" }  
    topic = Topic.find_by_id('1')
    assert_equal topic.posts_count, 31
    assert_equal topic.last_page, 2
    assert_redirected_to :controller => 'topics', :action => 'show', :id => '1', :page => '2', :anchor => 'p' + Post.last.id.to_s
  end

  def test_post_update_redirects_to_correct_page
    login_as :trevor
    post :create, :post => { :topic_id => "1", :body => "this is a test" }  
    assert_redirected_to :controller => 'topics', :action => 'show', :id => '1', :page => '1', :anchor => 'p' + Post.last.id.to_s
  end

  def test_post_edit_works_if_creator
    login_as :trevor
    get :edit, :id => posts(:one1)
    assert_response :success
  end
  
  def test_post_edit_works_if_admin
    login_as :Administrator
    get :edit, :id => posts(:one1)
    assert_response :success
  end
  
  def test_post_edit_does_not_work_if_not_creator_or_admin
    login_as :Timothy
    get :edit, :id => posts(:one1)
    assert_redirected_to root_path
  end
  
  def test_post_edit_does_not_work_if_not_logged_in
    get :edit, :id => posts(:one1)
    assert_redirected_to login_path
  end

  def test_post_update_works_if_creator
    login_as :trevor
    put :update, :id => posts(:one1), :post => { :body => 'edit!!!' }
    posts(:one1).reload
    assert_equal posts(:one1).body, 'edit!!!'
  end
  
  def test_post_update_works_if_admin
    login_as :Administrator
    put :update, :id => posts(:one1), :post => { :body => 'admin!!!' }
    posts(:one1).reload
    assert_equal posts(:one1).body, 'admin!!!'
  end
  
  def test_post_update_doesnt_work_if_not_admin_or_creator
    login_as :Timothy
    put :update, :id => posts(:one1), :post => { :body => 'edit!!!' }
    posts(:one1).reload
    assert_equal posts(:one1).body, 'MyText'
  end
  
  def test_post_update_doesnt_work_if_not_logged_in
    put :update, :id => posts(:one1), :post => { :body => 'edit!!!' }
    posts(:one1).reload
    assert_equal posts(:one1).body, 'MyText'
  end
  
  def test_posts_count_increments_when_post_created
    login_as :trevor
    old_forum_post_count = Forum.find_by_id('1').posts_count
    old_topic_post_count = Topic.find_by_id('1').posts_count
    post :create, :post => { :topic_id => "1", :body => "this is a test" }
    new_forum_post_count = Forum.find_by_id('1').posts_count
    new_topic_post_count = Topic.find_by_id('1').posts_count
    assert_equal old_forum_post_count+1, new_forum_post_count
    assert_equal old_topic_post_count+1, new_topic_post_count
  end
  
  def test_posts_count_decrements_when_post_destroyed
    login_as :trevor
    old_forum_post_count = Forum.find_by_id('1').posts_count
    old_topic_post_count = Topic.find_by_id('1').posts_count
    delete :destroy, :id => posts(:one3).id
    new_forum_post_count = Forum.find_by_id('1').posts_count
    new_topic_post_count = Topic.find_by_id('1').posts_count
    assert_equal old_forum_post_count-1, new_forum_post_count
    assert_equal old_topic_post_count-1, new_topic_post_count
  end

  def test_show_action_should_work
    get :show, :id => 1
    assert_response :success
  end

  def test_locate_action_should_work
    get :topic, :id => 1
    assert_redirected_to :controller => 'topics', :action => 'show', :id => '1', :page => '1', :anchor => 'p1'
  end
  
  def test_quote_action_should_work
    login_as :trevor
    get :quote, :id => 1
    assert_response :success
  end
    
  def test_should_reset_last_post_info_for_topic_on_post_destroy
    login_as :Administrator
    assert_equal topics(:Testing).last_post_id, posts(:one3).id
    delete :destroy, :id => posts(:one3).id
    topics(:Testing).reload
    assert_equal topics(:Testing).last_post_id, posts(:one2).id
  end
  
  def test_should_not_allow_post_if_logged_in_and_locked
    login_as :Timothy
    old_post_count = Post.count
    post :create, :post => { :topic_id => "3", :body => "this is a test" }
    assert_equal old_post_count, Post.count
  end

  def test_should_allow_post_if_logged_in_and_locked_but_is_admin
    login_as :Administrator
    old_post_count = Post.count
    post :create, :post => { :topic_id => "3", :body => "this is a test" }
    assert_equal old_post_count+1, Post.count
  end

  def test_should_allow_post_if_logged_in_and_locked_but_is_topic_creator
    login_as :trevor
    old_post_count = Post.count
    post :create, :post => { :topic_id => "3", :body => "this is a test" }
    assert_equal old_post_count+1, Post.count
  end
  
  def test_should_work_when_quoting_a_post
    # quote an existing post
    # see new post template
    # post object should be a new post
    # body of new post should be body of quoted post
  end
  
  def test_user_posts_path_should_work
    get :index, :user_id => users(:trevor).id
    assert_response :success
    get :index, :user_id => users(:noposts).id
    assert_response :success
  end

end
