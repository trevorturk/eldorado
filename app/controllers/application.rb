class ApplicationController < ActionController::Base
  
  around_filter :set_timezone
  before_filter :auth_token_login, :check_bans, :update_online_at, :get_settings, :get_reminders
  helper_method :current_user, :logged_in?, :is_online?, :admin?, :can_edit?, :require_login, :require_admin, :redirect_home
  
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  
  session :session_key => '_eldorado_session_id'
  filter_parameter_logging "password"
    
  include AuthenticationSystem, ExceptionLoggable
  
  protected
  
  def redirect_home
    redirect_to root_path and return false
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
    @ban = Ban.find(:first, :conditions => ["user_id = ? or ip = ? or email = ? and (expires_at > ? or expires_at is ?)", current_user.id, request.remote_ip, current_user.email, Time.now.utc, nil])
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
  
  def set_timezone
    TzTime.zone = logged_in? ? current_user.tz : TZInfo::Timezone.get('UTC')
    yield
    TzTime.reset!
  end
  
  def get_reminders
    @reminders = Event.find(:all, :order => 'date asc', :conditions => ["reminder = ?", true])
    @reminders = [] unless logged_in?
  end
  
  def record_not_found
    flash[:notice] = "Sorry, the page you requested was not found."
    redirect_to root_path
  end
  
  def get_settings
    @newest_user = User.find(:first, :order => "created_at desc")
    @settings = Setting.find(:first)
    if @settings.blank? # set default settings
      return if (Category.count != 0) || (Forum.count != 0) || (Setting.count != 0) || (Post.count != 0) || (Topic.count != 0) || (User.count != 0)
      @setting = Setting.new(:title => 'El Dorado.org', :tagline => 'All an elaborate, unapproachable, unprofitable, retributive joke', :announcement => '', :footer => '<p style="text-align:right;margin:0;">Powered by El Dorado | <a href="http://almosteffortless.com">&aelig;</a></p>')
      @setting.save!
      @category = Category.new(:name => 'Test Category')
      @category.save!
      @forum = @category.forums.build(:name => 'Test Forum', :description => "This is just a test forum")
      @forum.save!
      char = ("a".."z").to_a + ("1".."9").to_a; pass = Array.new(6, '').collect{char[rand(char.size)]}.join
      @user = User.new(:login => 'Administrator', :email => 'example@example.com', :password => pass) 
      @user.admin = true
      @user.save!
      @topic = @user.topics.build(:title => 'Test post', :forum_id => 1)
      @topic.save!
      @post = @user.posts.build(:body => 'This is just a test post')
      @post.topic_id = 1
      @post.save!
      flash[:notice] = "Setup complete. You can now log in as 'Administrator' with the password '#{pass}'"
      @settings = Setting.find(:first)
      @category = nil; @forum = nil; @user = nil; @topic = nil; @post = nil # reset for page_title
    end
  end
  
end