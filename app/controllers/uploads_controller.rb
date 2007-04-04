class UploadsController < ApplicationController
  
  before_filter :redirect_to_home, :only => [:show, :edit, :update]
  before_filter :force_login, :except => [:index, :show]
  
  def index
    if request.post?
      flash[:notice] = "Post Request"
    else
      flash[:notice] = "Not a Post Request"
    end
    @uploads = Upload.find(:all, :order => 'updated_at desc')
    @filter_users = Upload.find(:all, :group => 'user_id', :include => [:user])
    @filter_types = Upload.find(:all, :group => 'content_type')
  end

  def new
    @upload = Upload.new
    render :template => "uploads/_new"
  end

  def create
    @upload = current_user.uploads.build params[:upload]
    if @upload.save
      flash[:notice] = "File uploaded successfully"
      redirect_to files_home_path
    else
      render :template => "uploads/_new"
    end
  end

  def destroy
    @upload = Upload.find(params[:id])
    redirect_to files_home_path and return false unless admin? || (current_user == @upload.user)
    @upload.destroy
    redirect_to files_home_path
  end
  
end
