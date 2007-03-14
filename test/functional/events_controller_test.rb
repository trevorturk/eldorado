require File.dirname(__FILE__) + '/../test_helper'
require 'events_controller'

# Re-raise errors caught by the controller.
class EventsController; def rescue_action(e) raise e end; end

class EventsControllerTest < Test::Unit::TestCase
  fixtures :events

  def setup
    @controller = EventsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:events)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_event
    old_count = Event.count
    post :create, :event => {:title => "test", :description => "test", :date => Time.now }
    assert_equal old_count+1, Event.count
    
    assert_redirected_to events_path
  end

  def test_should_show_event
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_event
    put :update, :id => 1, :event => { }
    assert_redirected_to events_path
  end
  
  def test_should_destroy_event
    old_count = Event.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Event.count
    
    assert_redirected_to events_path
  end
end
