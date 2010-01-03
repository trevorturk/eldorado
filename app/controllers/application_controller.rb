class ApplicationController < ActionController::Base
  
  helper :all
  protect_from_forgery
  filter_parameter_logging :password
  
  include AuthenticationSystem, ExceptionHandler
  
  before_filter :get_settings, :auth_token_login, :check_bans, :check_privacy, :check_admin_only_create, :set_timezone, :update_online_at, :get_layout_vars
  helper_method :current_action, :current_controller, :current_user, :logged_in?, :logged_out?, :is_online?, :admin?, :can_edit?, :locked_out?
  
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  rescue_from ActiveRecord::SettingsNotFound, :with => :default_settings
  rescue_from ActionController::InvalidAuthenticityToken, :with => :generic_error
  rescue_from ActionView::MissingTemplate, :with => :not_found
  rescue_from WillPaginate::InvalidPage, :with => :invalid_page
  
  def redirect_home
    redirect_to root_path and return false
  end
  
  def get_settings
    @settings ||= Setting.find(:first)
    raise ActiveRecord::SettingsNotFound if @settings.nil?
  end
  
  def set_timezone
    Time.zone = logged_in? ? current_user.time_zone : @settings.time_zone
  end
  
  def get_layout_vars
    @users_online = User.online
    @users_newest = User.last
    @event_reminders = Event.reminders
  end
  
  def update_online_at
    return unless logged_in?
    session[:online_at] = current_user.online_at.utc if current_user.online_at.utc + 10.minutes < Time.now.utc
    current_user.update_attribute(:online_at, Time.now.utc)
  end
  
  def current_action
    request.path_parameters['action']
  end
  
  def current_controller
    request.path_parameters['controller']
  end
  
  def find_parent_user_or_class
    @parent_user = User.find(params[:user_id]) if params[:user_id]
    @parent = @parent_user ? @parent_user.send(current_controller) : current_controller.singularize.classify.constantize
  end
end
