class UploadsController < ApplicationController
  
  before_filter :redirect_home, :only => [:show, :edit, :update]
  before_filter :require_login, :except => [:index]
  
  def index
    if logged_in?
      @uploads = Upload.paginate(:page => params[:page], :per_page => Topic::PER_PAGE, :order => 'updated_at desc')
    else
      @uploads = Upload.paginate(:page => params[:page], :per_page => Topic::PER_PAGE, :order => 'updated_at desc', :conditions => ["private = ?", false])
    end
  end

  def new
    @upload = Upload.new
    render :template => "uploads/_new"
  end

  def create
    @upload = current_user.uploads.build params[:upload]
    if @upload.save
      flash[:notice] = "#{home_url.chop + @upload.public_filename}"
      redirect_to files_root_path
    else
      render :template => "uploads/_new"
    end
  end

  def destroy
    @upload = Upload.find(params[:id])
    redirect_to root_path and return false unless admin? || (current_user == @upload.user)
    @upload.destroy
    redirect_to files_root_path
  end
    
end
