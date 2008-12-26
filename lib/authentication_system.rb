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

  def locked_out?()
    return true if @settings.private? && !logged_in?
  end
  
  def logged_out?()
    return true if current_user.logged_out?
  end
      
  def require_login
    redirect_to login_path and return false unless logged_in?
  end

  def require_admin
    redirect_to root_path and return false unless admin?
  end

  def check_privacy
    redirect_to login_path and return false if locked_out?
  end
  
  def auth_token_login
    return if logged_in? || cookies[:auth_token].nil?
    user = User.find_by_auth_token(cookies[:auth_token])
    if user && Time.now.utc < user.auth_token_exp
      session[:user_id] = user.id 
      session[:online_at] = user.online_at
      redirect_to request.request_uri and return false
    end
  end
  
  def check_bans
    return unless logged_in?
    return if current_action == 'logout'
    return if current_user.banned_until.blank?
    if current_user.banned_until > Time.now.utc
      flash[:notice] = 'This account is banned' 
      flash[:notice] << ' until ' + current_user.banned_until.strftime("%B %d, %Y")
      flash[:notice] << ' with the message: ' + current_user.ban_message unless current_user.ban_message.blank?
      redirect_to logout_path and return false
    end
  end
  
  def check_admin_only_create
    if @settings.admin_only_create.include?(current_controller) && %w(new create).include?(current_action)
      redirect_to root_path unless admin?
    end
  end
  
  def can_edit
    redirect_to root_path and return false unless logged_in?
    klass = current_controller.camelize.singularize.constantize
    @item = klass.find(params[:id])
    if current_controller == "users"
      redirect_to root_path and return false unless admin? || (current_user == @item)
    else
      redirect_to root_path and return false unless admin? || (current_user == @item.user)
    end
  end
      
  def can_edit?(current_item)
    return false unless logged_in?
    if current_controller == "users"
      return current_user.admin? || (current_user == current_item) 
    else
      return current_user.admin? || (current_user.id == current_item.user_id) 
    end
  end

end