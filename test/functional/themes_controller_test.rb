require 'test_helper'

class ThemesControllerTest < ActionController::TestCase
  
  test "should get index/new if admin" do
    login!(:admin => true)
    get :index
    assert_response :success
    get :new
    assert_response :success
  end
  
  test "should not get index/new if not admin" do
    login!
    get :index
    assert_redirected_to root_path
    get :new
    assert_redirected_to root_path
  end
  
  test "should not get index/new if not logged in" do
    get :index
    assert_redirected_to root_path
    get :new
    assert_redirected_to root_path
  end
  
  test "should create theme if admin" do
    login!(:admin => true)
    assert_difference 'Theme.count' do
      post :create, :theme => { :attachment => fixture_file_upload('files/test.css', 'text/css') }
    end
    assert_redirected_to themes_path
  end
  
  test "should not create theme if not admin" do
    login!
    assert_no_difference 'Theme.count' do
      post :create, :theme => { :attachment => fixture_file_upload("files/test.css", 'text/css') }
    end
    assert_redirected_to root_path
  end
  
  test "should not create theme if not logged in" do
    assert_no_difference 'Theme.count' do
      post :create, :theme => { :attachment => fixture_file_upload("files/test.css", 'text/css') }
    end
    assert_redirected_to root_path
  end
  
  test "should not create theme if not a css file" do
    login!(:admin => true)
    assert_no_difference 'Theme.count' do
      post :create, :theme => { :attachment => fixture_file_upload('files/rails.png', 'image/png') }
    end
    assert_response :success # TODO figure out how to test with unit tests instead
  end
      
  test "show/edit/update redirect to root if not logged in, if logged in, and if admin" do
    get :show, :id => Theme.make.id
    assert_redirected_to root_path
    get :edit, :id => Theme.make.id
    assert_redirected_to root_path
    put :update, :id => Theme.make.id
    assert_redirected_to root_path
    login!
    get :show, :id => Theme.make.id
    assert_redirected_to root_path
    get :edit, :id => Theme.make.id
    assert_redirected_to root_path
    put :update, :id => Theme.make.id
    login!(:admin => true)
    get :show, :id => Theme.make.id
    assert_redirected_to root_path
    get :edit, :id => Theme.make.id
    assert_redirected_to root_path
    put :update, :id => Theme.make.id
  end
  
  test "should destroy upload if admin" do
    u = login!(:admin => true)
    r = Theme.make
    assert_difference 'Theme.count', -1 do
      delete :destroy, :id => r.id
    end
    assert_redirected_to themes_path
  end
  
  test "should not destroy upload if not admin" do
    login!
    r = Theme.make
    assert_no_difference 'Theme.count' do
      delete :destroy, :id => r.id
    end
    assert_redirected_to root_path
  end
  
  test "should not destroy upload if not logged in" do  
    r = Theme.make
    assert_no_difference 'Theme.count' do
      delete :destroy, :id => r.id
    end
    assert_redirected_to root_path
  end
    
  test "should select/deselect if admin" do
    login!(:admin => true)
    r = Theme.make
    post :select, :id => r.id
    assert_equal r, Setting.current_theme
    assert_redirected_to themes_path
    post :deselect, :id => r.id
    assert_nil Setting.current_theme
    assert_redirected_to themes_path
  end
  
  test "should not select/deselect if not admin" do
    login!
    post :select, :id => Theme.make.id
    assert_redirected_to root_path
    post :deselect, :id => Theme.make.id
    assert_redirected_to root_path
  end
  
  test "should not select/deselect if not logged_in" do
    post :select, :id => Theme.make.id
    assert_redirected_to root_path
    post :deselect, :id => Theme.make.id
    assert_redirected_to root_path
  end
    
end
