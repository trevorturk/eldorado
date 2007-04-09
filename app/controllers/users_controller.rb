class UsersController < ApplicationController
  
  before_filter :find_user, :only => [:edit, :update, :destroy]
  before_filter :can_edit_user, :only => [:edit, :update, :destroy]
  
  filter_parameter_logging "password"
  
  def index
    @users = User.find(:all, :order => 'last_login_at desc')
  end

  def show
    @user = User.find(params[:id])   
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    render :action => :new and return unless @user.save
    flash[:notice] = "Your account has been created"
    do_login(@user)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user.update_attributes(params[:user])
    @user.profile_updated_at = Time.now.utc
    @user.save!
    redirect_to user_path(@user)
  end
  
  def destroy
    @user.destroy
    redirect_to users_path
  end
  
  def login
    redirect_to home_path if logged_in?
    if request.post?
      @user = User.authenticate(params[:user][:login], params[:user][:password]) 
      if @user
        do_login(@user)
      else
        flash[:notice] = "Invalid user/password combination"
        render :action => :login
      end
    end
  end
  
  def logout
    reset_online_at
    reset_session
    redirect_to home_path
  end
    
  protected
    
  def find_user
    @user = params[:id] ? User.find_by_id(params[:id]) : current_user
  end
  
  def can_edit_user
    @user = User.find(params[:id])
    redirect_to user_path(@user) and return false unless admin? || (current_user == @user)
  end
  
  def do_login(user)
    if (!user.banned_until.blank?) && (user.banned_until > Time.now.utc.to_date)
      flash[:notice] = user.login+" is banned until "+user.banned_until.to_s(:long)+" with the message: "+user.ban_message
      redirect_to login_path and return false
    end
    session[:user_id] = user.id
    session[:last_session_at] = user.last_login_at
    user.last_login_at = Time.now.utc
    user.save!
    redirect_to home_path
  end
  
end
