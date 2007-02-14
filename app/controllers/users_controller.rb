class UsersController < ApplicationController
  
  before_filter :find_user, :only => [:edit, :update, :destroy]
  
  def index
    @users = User.find(:all, :order => 'last_login_at desc')
  end

  def show
    @user = User.find(params[:id])
    if @user.id == current_user.id
      @current_user_profile = true
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.last_login_at = Time.now.utc
    if @user.save
      flash[:notice] = "Your account has been created. Please log in."
      redirect_to login_path
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_to user_path(@user)
    else
      redirect_to user_path(@user)
    end
  end
  
  def login
    reset_session
    if @current_user_id
      redirect_to login_path
    end
    if request.post?
      user = User.authenticate(params[:login], params[:password])
      if user
        session[:user_id] = user.id
        user.last_login_at = Time.now.utc
        user.save!
        redirect_to home_path
      else
        flash[:notice] = "Invalid user/password combination"
      end
    end
  end
  
  def logout
    reset_session
    redirect_to home_path
  end
  
  def find_user
    @user = params[:id] ? User.find_by_id(params[:id]) : current_user
  end
  
end
