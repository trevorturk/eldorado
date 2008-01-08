class ApplicationController < ActionController::Base
  
  helper :all
  protect_from_forgery
  filter_parameter_logging 'password'
  session :session_key => '_eldorado_session_id'
  
  include AuthenticationSystem, ExceptionHandler, ExceptionLoggable
  
  around_filter :get_settings, :set_timezone
  before_filter :get_newest_user, :auth_token_login, :check_bans, :update_online_at, :get_reminders
  helper_method :current_user, :logged_in?, :is_online?, :admin?, :can_edit?
  
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  rescue_from ActionController::InvalidAuthenticityToken, :with => :generic_error
  rescue_from WillPaginate::InvalidPage, :with => :invalid_page
  
  def redirect_home
    redirect_to root_path and return false
  end
  
  protected
  
  def get_settings
    @settings ||= Setting.find(:first)
    if @settings.nil?
      @settings = Setting.new(:title => 'El Dorado', :tagline => 'All an elaborate, unapproachable, unprofitable, retributive joke', :footer => '<p style="text-align:right;margin:0;">Powered by El Dorado | <a href="http://almosteffortless.com">&aelig;</a></p>')
      @settings.save!
      flash[:notice] = 'Welcome to El Dorado! Please create a new user account for yourself.'
      redirect_to new_user_path
    end
    yield
  end
  
  def set_timezone
    TzTime.zone = logged_in? ? current_user.tz : @settings.tz
    yield
    TzTime.reset!
  end
    
  def get_newest_user
    @newest_user = User.find(:first, :order => "created_at desc")
  end
  
  def get_reminders
    @reminders = Event.find(:all, :order => 'date asc', :conditions => ['reminder = ?', true])
    @reminders = [] unless logged_in?
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
    return if request.path_parameters['action'] == 'logout'
    @ban = Ban.find(:first, :conditions => ['user_id = ? or ip = ? or email = ? and (expires_at > ? or expires_at is ?)', current_user.id, request.remote_ip, current_user.email, Time.now.utc, nil])
    if @ban
      flash[:notice] = 'This account is banned' 
      flash[:notice] << ' until ' + @ban.expires_at.strftime("%B %d, %Y") unless @ban.expires_at.blank?
      flash[:notice] << ' with the message: ' + @ban.message unless @ban.message.blank?
      redirect_to logout_path and return false
    end
  end
  
  def update_online_at
    return unless logged_in?
    session[:online_at] = current_user.online_at.utc if current_user.online_at.utc + 10.minutes < Time.now.utc
    User.update_all ['online_at = ?', Time.now.utc], ['id = ?', current_user.id]
  end
          
end