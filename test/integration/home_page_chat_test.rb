require "test_helper"

class HomePageChatTest < ActionController::IntegrationTest
  fixtures :all

  def test_home_page_with_recent_chat_activity
    get "/login"
    assert_response :success
    post "/login", :user => {:login => 'trevor', :password => 'test'}
    assert_response :redirect
    get "/chat"
    assert_response :success
    get "/"
    assert_response :success    
  end
end
