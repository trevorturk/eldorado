class ApplicationController < ActionController::Base
  
  helper_method :current_user, :logged_in?, :force_login, :reset_online_at, :is_online?, :admin?, :check_admin
  before_filter :update_online_at
    
  session :session_key => '_eldorado_session_id'
  
  protected

  def current_user
    @current_user ||= ((session[:user_id] && User.find_by_id(session[:user_id])) || 0)
  end
    
  def logged_in?()
    current_user != 0
  end
  
  def force_login
    redirect_to login_path and return false unless logged_in?
  end
  
  def update_online_at
    return unless logged_in?
    User.update_all ['online_at = ?', Time.now.utc], ['id = ?', current_user.id] 
    current_user.online_at = Time.now.utc
  end
  
  def reset_online_at
    User.update_all ['online_at = ?', Time.now.utc-5.minutes], ['id = ?', current_user.id] 
    current_user.online_at = Time.now.utc
  end
  
  def is_online?(user)
    User.find(:first, :conditions => ["id = ? and online_at > ?", user.id, Time.now.utc-5.minutes])
  end
  
  def admin?()
    logged_in? && (current_user.admin == true)
  end
  
  def check_admin
    redirect_to home_path and return false unless admin?
  end
      
end