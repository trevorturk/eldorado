require "test_helper"

class AdminOnlyCreateTest < ActionController::IntegrationTest
  fixtures :all

  def test_admin_only_create
    post "/login", :user => {:login => 'trevor', :password => 'test'}
    get "/articles/new"
    assert_response :success
    assert_difference 'Article.count' do
      post "/articles", :article => {:title => 'test admin only create', :body => 'post'}
    end
    Setting.first.update_attribute(:admin_only_create, 'articles')
    get "/articles"
    assert_response :success
    get "/articles/new"
    assert_redirected_to root_path
    assert_no_difference 'Article.count' do
      post "/articles", :article => {:title => 'test admin only create', :body => 'post'}
    end
    assert_redirected_to root_path
    get '/logout'
    post "/login", :user => {:login => 'Administrator', :password => 'test'}
    get "/articles/new"
    assert_response :success
    assert_difference 'Article.count' do
      post "/articles", :article => {:title => 'test admin only create with admin', :body => 'post'}
    end
  end
end
