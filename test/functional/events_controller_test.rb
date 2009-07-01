require 'test_helper'

class EventsControllerTest < ActionController::TestCase

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:events)
  end

  # def test_should_get_new
  # end
  
  def test_should_create_event
    login_as :trevor
    old_count = Event.count
    post :create, :event => {:title => "test", :description => "test", :date => Time.now.utc }
    assert_equal old_count+1, Event.count
    assert_redirected_to event_path(assigns(:event))
  end

  def test_should_show_event
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit_or_perform_update_if_admin
    login_as :Administrator
    get :edit, :id => 1
    assert_response :success
    put :update, :id => 1, :event => {:title => "test", :description => "test", :date => Time.now.utc}
    assert_redirected_to event_path(assigns(:event))
  end
  
  def test_should_get_edit_or_perform_update_if_user_that_made_it
    login_as :trevor
    get :edit, :id => 1
    assert_response :success
    put :update, :id => 1, :event => {:title => "test", :description => "test", :date => Time.now.utc}
    assert_redirected_to event_path(assigns(:event))
  end
  
  def test_should_not_get_edit_or_perform_update_if_not_logged_in
    get :edit, :id => 1
    assert_redirected_to login_path
    put :update, :id => 1, :event => {:title => "test", :description => "test", :date => Time.now.utc}
    assert_redirected_to login_path
  end
  
  def test_should_not_get_edit_or_perform_update_if_not_authorized
    login_as :Timothy
    get :edit, :id => 1
    assert_redirected_to root_path
    put :update, :id => 1, :event => {:title => "test", :description => "test", :date => Time.now.utc}
    assert_redirected_to root_path
  end
  
  def test_should_update_event
    login_as :Administrator
    put :update, :id => 1, :event => {:title => "test", :description => "test", :date => Time.now.utc}
    assert_redirected_to event_path(assigns(:event))
  end
  
  def test_should_destroy_event_if_creator
    old_count = Event.count
    login_as :trevor
    delete :destroy, :id => 1
    assert_equal old_count-1, Event.count
    assert_redirected_to events_path
  end
  
  def test_should_destroy_event_if_admin
    old_count = Event.count
    login_as :Administrator
    delete :destroy, :id => 1
    assert_equal old_count-1, Event.count
    assert_redirected_to events_path
  end
  
  def test_should_not_destroy_event_if_not_authorized
    old_count = Event.count
    delete :destroy, :id => 1
    assert_equal old_count, Event.count
    assert_redirected_to login_path
    login_as :Timothy
    delete :destroy, :id => 1
    assert_equal old_count, Event.count
    assert_redirected_to login_path
  end
  
  # def test_should_create_event_with_correct_time_for_user_time_zone
  # end
  
  # def test_should_show_reminder_on_correct_date_for_current_user
  # end
end
