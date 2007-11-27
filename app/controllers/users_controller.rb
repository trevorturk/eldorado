class UsersController < ApplicationController
  
  before_filter :can_edit, :only => [:edit, :update, :destroy, :confirm_delete]
  
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
    render :action => :new and return unless @user.save
    flash[:notice] = "The new user has been created."
    if logged_in?
      redirect_to users_path and return
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
      redirect_to edit_user_path(@user)
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
  
  def login
    redirect_to root_path if logged_in?
    if request.post?
      @user = User.authenticate(params[:user][:login], params[:user][:password]) 
      if @user
        do_login(@user)
      else
        flash[:notice] = "Invalid user/password combination"
        render :action => :login and return false
      end
    end
  end
  
  def logout
    redirect_to root_path and return false unless logged_in?
    @flash = flash[:notice]
    @user = User.find_by_id(session[:user_id])
    if @user
      @user.auth_token = nil
      @user.auth_token_exp = nil
      @user.save!
    end
    cookies.delete :auth_token
    reset_session
    flash[:notice] = @flash
    redirect_to root_path
  end
    
  protected
    
  def do_login(user)
    session[:user_id] = user.id
    session[:online_at] = user.online_at
    user.online_at = Time.now.utc
    user.auth_token = Digest::SHA1.hexdigest(Time.now.to_s + rand(123456789).to_s)
    user.auth_token_exp = 2.weeks.from_now
    cookies[:auth_token] = { :value => user.auth_token, :expires => user.auth_token_exp }
    user.save!
    redirect_to root_path
  end
  
end
