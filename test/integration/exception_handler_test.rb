require "test_helper"

class ExceptionHandlerTest < ActionController::IntegrationTest
  fixtures :all

  def test_exception_handler
    # topics/test_should_redirect_to_topic_with_empty_viewtopic_php_style_url
    get '/viewtopic.php'
    assert_redirected_to root_path
    
    # topics/test_should_be_ok_with_bogus_params_page_value
    get '/topics/1/?page=sdf'
    assert_redirected_to root_path
    assert_equal "Sorry, the page number you requested was not valid.", flash[:notice]
    
    # home/test_should_catch_request_with_cgi_in_path
    # e.g. http://localhost:3000/topics.cgi?topic=1
    get 'topics.cgi?topic=1'
    assert_redirected_to root_path
    
    # home/test_initial_setup_should_work
    User.destroy_all
    Setting.destroy_all
    get '/'
    assert_redirected_to new_user_path
    assert_equal 'UTC', Setting.first.time_zone
  end
end
