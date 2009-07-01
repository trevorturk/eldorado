require 'test_helper'

class SettingsControllerTest < ActionController::TestCase

  def test_should_not_get_index_if_not_authorized
    get :index 
    assert_redirected_to root_path
    login_as :trevor
    assert_redirected_to root_path
  end
  
  def test_should_get_index_if_authorized
    login_as :Administrator
    get :index 
    assert_response :success
  end

  def test_should_not_update_if_not_authorized
    put :update, :id => 1, :setting => { :title => 'test' }
    assert_redirected_to root_path
    settings(:one).reload
    assert_equal "El Dorado", settings(:one).title
    login_as :trevor
    put :update, :id => 1, :setting => { :title => 'test' }
    assert_redirected_to root_path
    settings(:one).reload
    assert_equal "El Dorado", settings(:one).title
  end
  
  def test_should_update_if_authorized
    login_as :Administrator
    put :update, :id => 1, :setting => { :title => 'test' }
    assert_redirected_to settings_path
    settings(:one).reload
    assert_equal "test", settings(:one).title
  end
end
