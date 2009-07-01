class UploadsController < ApplicationController
  
  before_filter :redirect_home, :only => [:show, :edit, :update]
  before_filter :require_login, :except => [:index]
  before_filter :can_edit, :only => [:destroy]
  
  rescue_from Errno::ENOENT, :with => :url_upload_not_found
  rescue_from Errno::ETIMEDOUT, :with => :url_upload_not_found
  rescue_from OpenURI::HTTPError, :with => :url_upload_not_found
  
  def index
    @uploads = Upload.paginate(:page => params[:page], :order => 'updated_at desc')
  end

  def new
  end

  def create
    @upload = current_user.uploads.new(params[:upload])
    if @upload.save
      if CONFIG['s3']
        flash[:notice] = "#{@upload.attachment.url.split('?').first}"
      else
        flash[:notice] = "#{root_url.chop + @upload.attachment.url.split('?').first}"
      end
      redirect_to files_path
    else
      render :action => "new"
    end
  end

  def destroy
    @upload = Upload.find(params[:id])
    @upload.destroy
    redirect_to files_path
  end
end
