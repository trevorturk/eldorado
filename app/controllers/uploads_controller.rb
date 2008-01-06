class UploadsController < ApplicationController
  
  before_filter :redirect_home, :only => [:show, :edit, :update]
  before_filter :require_login, :except => [:index]
  before_filter :can_edit, :only => [:destroy]
  
  def index
    if logged_in?
      @uploads = Upload.paginate(:page => params[:page], :order => 'updated_at desc')
    else
      @uploads = Upload.paginate(:page => params[:page], :order => 'updated_at desc', :conditions => ["private = ?", false])
    end
  end

  def new
  end

  def create
    @upload = current_user.uploads.build params[:upload]
    if @upload.save
      flash[:notice] = "#{root_url.chop + @upload.public_filename}"
      redirect_to files_root_path
    else
      render :action => "new"
    end
  end

  def destroy
    @upload = Upload.find(params[:id])
    @upload.destroy
    redirect_to files_root_path
  end
    
end
