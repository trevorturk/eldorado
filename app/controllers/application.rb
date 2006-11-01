# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base

  include ExceptionLoggable
  
  helper_method :current_user, :logged_in?
  before_filter :instantiate_current_vars
    
  session :session_key => '_eldorado_session_id'
  
  protected
    
  def instantiate_current_vars
    @current_action = action_name
    @current_controller = controller_name
  end
  
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