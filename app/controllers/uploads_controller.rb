class UploadsController < ApplicationController
  
  before_filter :force_login, :except => [:index, :show]
  before_filter :can_edit_upload, :only => [:destroy]
  
  def index
    @uploads = Upload.find(:all, :order => 'updated_at desc')
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @uploads.to_xml }
    end
  end

  def show
    redirect_to uploads_path
  end

  def new
    @upload = Upload.new
  end

  def edit
    redirect_to uploads_path
  end

  def create
    @upload = Upload.new(params[:upload])
    @upload.user_id = current_user.id
    respond_to do |format|
      if @upload.save
        flash[:notice] = "File uploaded successfully"
        format.html { redirect_to uploads_url }
        format.xml  { head :created, :location => uploads_url }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @upload.errors.to_xml }
      end
    end
  end
  
  def update
    redirect_to uploads_path
  end

  def destroy
    @upload = Upload.find(params[:id])
    @upload.destroy
    respond_to do |format|
      format.html { redirect_to files_home_path }
      format.xml  { head :ok }
    end
  end
  
  def can_edit_upload
    @upload = Upload.find(params[:id])
    redirect_to upload_path(@upload) and return false unless admin? || (current_user == @upload.user)
  end
  
end
