require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:articles)
  end

  def test_should_get_rss_feed
    get :index, :format => 'rss'
    assert_response :success
    assert_template 'index', :format => 'rss'
  end
  
  def test_should_get_rss_feed_if_no_articles
    Article.destroy_all
    get :index, :format => 'rss'
    assert_response :success
    assert_template 'index', :format => 'rss'
  end
  
  def test_should_not_get_rss_feed_if_private
    private_site
    get :index, :format => 'rss'
    assert_redirected_to login_path
  end

  def test_should_get_new_if_logged_in
    login_as :trevor
    get :new
    assert_response :success
  end
  
  def test_should_not_get_new_if_not_logged_in
    get :new
    assert_redirected_to login_path
  end

  def test_should_create_article_if_logged_in
    login_as :trevor
    assert_difference('Article.count') do
      post :create, :article => { :title => 'title', :body => 'body' }
    end
    assert_redirected_to article_path(assigns(:article))
  end

  def test_should_show_article
    get :show, :id => articles(:one).id
    assert_response :success
  end

  def test_should_get_edit_if_admin
    login_as :Administrator
    get :edit, :id => articles(:one).id
    assert_response :success
  end
  
  def test_should_get_edit_if_creator
    login_as :trevor
    get :edit, :id => articles(:one).id
    assert_response :success
  end
  
  def test_should_not_get_edit_if_not_authorized
    login_as :Timothy
    get :edit, :id => articles(:one).id
    assert_redirected_to root_path
  end
  
  def test_should_not_get_edit_if_not_logged_in
    get :edit, :id => articles(:one).id
    assert_redirected_to login_path
  end

  def test_should_update_article_if_admin
    login_as :Administrator
    put :update, :id => articles(:one).id, :article => { :title => 'test!'}
    assert_redirected_to article_path(assigns(:article))
    articles(:one).reload
    assert_equal 'test!', articles(:one).title
  end
  
  def test_should_update_article_if_creator
    login_as :trevor
    put :update, :id => articles(:one).id, :article => { }
    assert_redirected_to article_path(assigns(:article))
  end
  
  def test_should_not_update_article_if_not_authorized
    login_as :Timothy
    put :update, :id => articles(:one).id, :article => { }
    assert_redirected_to root_path
  end
  
  def test_should_not_update_article_if_not_logged_in
    put :update, :id => articles(:one).id, :article => { }
    assert_redirected_to login_path
  end
  
  def test_should_destroy_article_if_admin
    login_as :Administrator
    assert_difference('Article.count', -1) do
      delete :destroy, :id => articles(:one).id
    end
    assert_redirected_to blog_path
  end
  
  def test_should_destroy_article_if_creator
    login_as :trevor
    assert_difference('Article.count', -1) do
      delete :destroy, :id => articles(:one).id
    end
    assert_redirected_to blog_path
  end
  
  def test_should_not_destroy_article_if_not_authorized
    login_as :Timothy
    assert_no_difference('Article.count') do
      delete :destroy, :id => articles(:one).id
    end
    assert_redirected_to root_path
  end
  
  def test_should_not_destroy_article_if_not_logged_in
    assert_no_difference('Article.count') do
      delete :destroy, :id => articles(:one).id
    end
    assert_redirected_to login_path
  end
  
  def test_user_articles_path_should_work
    get :index, :user_id => users(:trevor).id
    assert_response :success
    get :index, :user_id => users(:noposts).id
    assert_response :success
  end
  
  def test_articles_archives_path_should_work
    get :archives
    assert_response :success
  end
end
