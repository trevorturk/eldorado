require 'test_helper'

class HeadersControllerTest < ActionController::TestCase
  
  test "should get index (logged in or not)" do
    get :index
    assert_response :success
    login!
    get :index
    assert_response :success
  end

  test "should get new if logged in" do
    login!
    get :new
    assert_response :success
  end
  
  test "should not get new if not logged in" do
    login!
    get :new
    assert_response :success
  end
  
  test "should create header if logged in" do
    login!
    assert_difference 'Header.count' do
      post :create, :header => { :attachment => fixture_file_upload('files/header.jpg', 'image/jpg') }
    end
    assert_redirected_to assigns(:header)
  end
  
  test "should not create header if not logged in" do
    assert_no_difference 'Header.count' do
      post :create, :header => { :attachment => fixture_file_upload('files/header.jpg', 'image/jpg') }
    end
    assert_redirected_to login_path
  end
    
  test "show if logged in or not" do
    r = Header.make
    get :show, :id => r.id
    assert_response :success
    assert_equal r, assigns(:header)
    login!
    get :show, :id => r.id
    assert_response :success
    assert_equal r, assigns(:header)
  end
  
  test "should edit/update/destroy if creator" do
    flunk
  end
  
  test "should edit/update/destroy if admin" do
    flunk
  end
  
  test "should not edit/update/destroy if not creator or admin" do
    flunk
  end
  
  test "should not edit/update/destroy if not logged in" do
    flunk
  end
  
  test "should vote up/down if logged in" do
    flunk
  end
  
  test "should not vote up/down if not logged in" do
    flunk
  end

  test "should not create header if not an image" do
    login!
    assert_no_difference 'Header.count' do
      post :create, :theme => { :attachment => fixture_file_upload('files/header.jpg', 'image/jpg') }
    end
    assert_response :success # TODO figure out how to test with unit tests instead
  end
  
end
