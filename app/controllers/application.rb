class ApplicationController < ActionController::Base

  include ExceptionLoggable
  
  helper_method :current_user, :logged_in?
    
  session :session_key => '_eldorado_session_id'
  
  protected
    
  def current_user
    @current_user ||= ((session[:user_id] && User.find_by_id(session[:user_id])) || 0)
  end
        
  def 
    logged_in?() current_user != 0
  end
          
  def redirect_to_home(message)
    flash[:notice] = message if message
    redirect_to :controller => :forum, :action => :index
  end
  
end