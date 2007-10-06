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
  
  def require_login
    redirect_to login_path and return false unless logged_in?
  end
  
  def require_admin
    redirect_to root_path and return false unless admin?
  end
  
  def check_privacy
    klass = request.path_parameters['controller'].singularize.classify.constantize
    @item = klass.find(params[:id])
    redirect_to login_path if (!logged_in? && @item.private)
  end
    
  def can_edit
    return false unless logged_in?
    klass = request.path_parameters['controller'].singularize.classify.constantize
    @item = klass.find(params[:id])
    if request.path_parameters['controller'] == "users"
      redirect_to root_path and return false unless admin? || (current_user == @item)
    else
      redirect_to root_path and return false unless admin? || (current_user == @item.user)
    end
  end
      
  def can_edit?(current_item)
    return false unless logged_in?
    if request.path_parameters['controller'] == "users"
      return current_user.admin? || (current_user == current_item) 
    else
      return current_user.admin? || (current_user.id == current_item.user_id) 
    end
  end

end