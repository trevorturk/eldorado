require 'test_helper'

class RanksControllerTest < ActionController::TestCase
  
  def test_should_get_index
    get :index
    assert_response :success
  end
  
  def test_should_get_index_if_admin
    login_as :Administrator
    get :index
    assert_response :success
  end
  
  def test_should_get_new_if_admin
    login_as :Administrator
    get :new
    assert_response :success
  end
  
  def test_should_not_get_new_if_not_admin
    get :new
    assert_redirected_to root_path
  end
  
  def test_should_not_get_edit_unless_admin
    get :edit, :id => 1
    assert_redirected_to root_path
  end
  
  def test_should_get_edit_if_admin
    login_as :Administrator
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_not_update_topic_if_not_admin
    put :update, :id => 1, :rank => { :title => "bogus!"}
    assert_redirected_to root_path
    assert_equal "no_posts", ranks(:one).title
  end
  
  def test_should_update_topic_if_admin
    login_as :Administrator
    put :update, :id => 1, :rank => { :title => "ok!" }
    assert_redirected_to ranks_path
    assert_equal "ok!", ranks(:one).title
  end
  
  def test_should_destroy_if_admin
    login_as :Administrator
    old_count = Rank.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Rank.count
    assert_redirected_to ranks_path
  end
  
  def test_should_not_destroy_if_not_admin
    old_count = Rank.count
    delete :destroy, :id => 1
    assert_equal old_count, Rank.count
    assert_redirected_to root_path
  end
end
