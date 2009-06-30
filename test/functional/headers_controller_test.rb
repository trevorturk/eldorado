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
    get :new
    assert_redirected_to login_path
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
    u = login!
    r = Header.make(:user => u)
    get :edit, :id => r.id
    assert_response :success
    put :update, :id => r.id, :header => { :description => 'changed!' }
    r.reload
    assert_equal 'changed!', r.description
    assert_difference 'Header.count', -1 do
      delete :destroy, :id => r.id
      assert_redirected_to headers_path
    end
  end
  
  test "should edit/update/destroy if admin" do
    login!(:admin => true)
    r = Header.make
    get :edit, :id => r.id
    assert_response :success
    put :update, :id => r.id, :header => { :description => 'changed!' }
    r.reload
    assert_equal 'changed!', r.description
    assert_difference 'Header.count', -1 do
      delete :destroy, :id => r.id
      assert_redirected_to headers_path
    end
  end
  
  test "should not edit/update/destroy if not creator or admin" do
    login!
    r = Header.make
    get :edit, :id => r.id
    assert_redirected_to root_path
    put :update, :id => r.id, :header => { :description => 'changed!' }
    r.reload
    assert_not_equal 'changed!', r.description
    assert_no_difference 'Header.count' do
      delete :destroy, :id => r.id
      assert_redirected_to root_path
    end
  end
  
  test "should not edit/update/destroy if not logged in" do
    r = Header.make
    get :edit, :id => r.id
    assert_redirected_to login_path
    put :update, :id => r.id, :header => { :description => 'changed!' }
    r.reload
    assert_not_equal 'changed!', r.description
    assert_no_difference 'Header.count' do
      delete :destroy, :id => r.id
      assert_redirected_to login_path
    end
  end
  
  test "should vote up/down if logged in" do
    login!
    r = Header.make
    put :vote_up, :id => r.id
    assert_response :success
    r.reload
    assert_equal 1, r.votes
    put :vote_down, :id => r.id
    assert_response :success
    r.reload
    assert_equal 0, r.votes
  end
  
  test "should not vote up/down if not logged in" do
    r = Header.make(:votes => 21)
    put :vote_up, :id => r.id
    assert_redirected_to login_path
    r.reload
    assert_equal 21, r.votes
    put :vote_down, :id => r.id
    assert_redirected_to login_path
    r.reload
    assert_equal 21, r.votes
  end
  
  test "should not create header if not an image" do
    login!
    assert_no_difference 'Header.count' do
      post :create, :header => { :attachment => fixture_file_upload('files/test.css', 'text/css') }
    end
    assert_response :success # TODO figure out how to test with unit tests instead
  end
  
end
