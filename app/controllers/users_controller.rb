class UsersController < ApplicationController
  
  before_filter :can_edit, :only => [:edit, :update, :destroy, :confirm_delete]
  before_filter :require_admin, :only => [:admin, :ban, :remove_ban]
  skip_filter :check_privacy, :only => [:login, :logout]
  
  def index
    @users = User.paginate(:page => params[:page], :order => 'profile_updated_at desc')
    @users_count = User.count
  end

  def show
    @user = User.find(params[:id])
  end

  def new
  end

  def create
    @user = User.new(params[:user])
    render :action => :new and return false unless @user.save
    if logged_in?
      redirect_to users_path and return true
    else
      do_login(@user)
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    @user.profile_updated_at = Time.now.utc
    if @user.save
      redirect_to @user
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if params[:confirm] != "1"
      flash[:notice] = "You must check the confirmation box"
      redirect_to confirm_delete_user_path(@user)
    else
      @user.destroy
      redirect_to users_path
    end
  end

  def confirm_delete
    @user = User.find(params[:id])
  end
  
  def admin
    @user = User.find(params[:id])
    @user.toggle!(:admin)
    redirect_to user_path(@user)
  end
  
  def ban
    @user = User.find(params[:id])
  end
  
  def remove_ban
    @user = User.find(params[:id])
    @user.remove_ban
    redirect_to user_path(@user)
  end
    
  def login
    redirect_to root_path and return false if logged_in?
    if request.post?
      @user = User.authenticate(params[:user][:login], params[:user][:password]) unless params[:user].blank?
      if @user
        do_login(@user)
      else
        flash[:notice] = I18n.t(:invalid_user_password_combo)
        render :action => :login and return false
      end
    end
  end
  
  def logout
    redirect_to root_path and return false unless logged_in?
    @flash = flash[:notice]
    @user = User.find_by_id(session[:user_id])
    if @user
      @user.logged_out = true
      @user.auth_token = nil
      @user.auth_token_exp = nil
      @user.save!
    end
    cookies.delete :auth_token
    reset_session
    flash[:notice] = @flash
    redirect_to login_path
  end
    
  protected
    
  def do_login(user)
    user.logged_out = false
    user.online_at = Time.now.utc if user.online_at.nil?
    session[:user_id] = user.id
    session[:online_at] = user.online_at
    user.online_at = Time.now.utc
    user.auth_token = Digest::SHA1.hexdigest(Time.now.utc.to_s + rand(123456789).to_s) unless user.auth_token?
    user.auth_token_exp = 2.weeks.from_now
    cookies[:auth_token] = { :value => user.auth_token, :expires => user.auth_token_exp }
    user.save!
    redirect_to root_path
  end
end
