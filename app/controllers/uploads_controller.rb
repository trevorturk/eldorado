class UploadsController < ApplicationController
  require 'open-uri'
  
  before_filter :redirect_home, :only => [:show, :edit, :update]
  before_filter :require_login, :except => [:index]
  before_filter :can_edit, :only => [:destroy]
  
  rescue_from Errno::ENOENT, :with => :url_upload_not_found
  rescue_from Errno::ETIMEDOUT, :with => :url_upload_not_found
  rescue_from OpenURI::HTTPError, :with => :url_upload_not_found
  rescue_from Timeout::Error, :with => :url_upload_not_found
  
  def index
    @uploads = Upload.paginate(:page => params[:page], :order => 'updated_at desc')
  end

  def new
  end

  def create
    if params[:upload_url].blank?
      @upload = current_user.uploads.build(params[:upload])
    else
      @upload = current_user.uploads.build(:uploaded_data => UrlUpload.new(params[:upload_url]))
    end
    if @upload.save
      flash[:notice] = "#{root_url.chop + @upload.public_filename}"
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
