module AuthenticationSystem

  protected

  def current_user
    @current_user ||= ((session[:user_id] && User.find_by_id(session[:user_id])) || 0)
  end
    
  def logged_in?()
    current_user != 0
  end
  
  def admin?()
    logged_in? && (current_user.admin == true)
  end
  
  def force_login
    redirect_to login_path and return false unless logged_in?
  end
  
  def check_admin
    redirect_to root_path and return false unless admin?
  end    

end