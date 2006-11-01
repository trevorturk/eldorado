require 'digest/sha1'

class UsersController < ApplicationController

  before_filter :force_login, :only => [ :edit, :update, :detroy ]
  before_filter :authorize_and_initiate_sensitive_actions, :only => [ :edit, :update, :destroy ]
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @user_pages, @users = paginate :users, :per_page => 10
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
    if @user.save
      redirect_to_home("User was successfully created.")
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      redirect_to :action => 'show', :id => @user
    else
      render :action => 'edit'
    end
  end
  
  def login
    if @current_user_id
      reset_session
      redirect_to :action => 'login'
    end
    reset_session
    if request.post?
      user = User.authenticate(params[:login], params[:password])
      if user
        session[:user_id] = user.id
        user.last_login_at = Time.now
        user.save!
        redirect_to_home("You are now logged in.")
      else
        flash[:notice] = "Invalid user/password combination"
      end
    end
  end
  
  def logout
    reset_session
    redirect_to_home("You have been logged out.")
  end

  protected

  def force_login
    redirect_to_home("Please log in.") unless User.find_by_id(session[:user_id])
  end
      
  def authorize_and_initiate_sensitive_actions
    @user = User.find(params[:id])
    redirect_to_home("Sorry, there was an error.") and return unless @user[:id] == current_user.id
  end
  
end
