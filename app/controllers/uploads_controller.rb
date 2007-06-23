class UploadsController < ApplicationController
  
  before_filter :redirect_to_home, :only => [:show, :edit, :update]
  before_filter :force_login, :except => [:index]
  
  def index
    @uploads = Upload.paginate(:page => params[:page], :order => 'updated_at desc')
  end

  def new
    @upload = Upload.new
    render :template => "uploads/_new"
  end

  def create
    @upload = current_user.uploads.build params[:upload]
    if @upload.save
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
