class ApplicationController < ActionController::Base
  
  helper_method :current_user, :logged_in?, :force_login
    
  session :session_key => '_eldorado_session_id'
  
  protected
  
  def force_login
    redirect_to home_path and return false unless User.find_by_id(session[:user_id])
  end
  
  def current_user
    @current_user ||= ((session[:user_id] && User.find_by_id(session[:user_id])) || 0)
  end
        
  def logged_in?()
    current_user != 0
  end
            
  def redirect_to_home(message)
    flash[:notice] = message if message
    redirect_to home_path
  end
  
end