require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  
  def test_should_get_index
    login_as :trevor
    get :index
    assert_response :success
  end
  
  def test_should_accept_searches
    # TODO add Model.make for all types being searched
    login_as :trevor
    get :index, :type => 'articles', :query => 'test'
    assert_response :success
    get :index, :type => 'avatars', :query => 'test'
    assert_response :success
    get :index, :type => 'events', :query => 'test'
    assert_response :success
    get :index, :type => 'files', :query => 'test'
    assert_response :success
    get :index, :type => 'headers', :query => 'test'
    assert_response :success
    get :index, :type => 'messages', :query => 'test'
    assert_response :success
    get :index, :type => 'posts', :query => 'test'
    assert_response :success
    get :index, :type => 'topics', :query => 'test'
    assert_response :success
    get :index, :type => 'users', :query => 'test'
    assert_response :success
  end
  
end
