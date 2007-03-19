class UploadsController < ApplicationController
  
  before_filter :force_login, :except => [:index, :show]
  before_filter :can_edit_upload, :only => [:edit, :update, :destroy]
  
  def index
    @uploads = Upload.find(:all)
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @uploads.to_xml }
    end
  end

  def show
    @upload = Upload.find(params[:id])
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @upload.to_xml }
    end
  end

  def new
    @upload = Upload.new
  end

  def edit
    @upload = Upload.find(params[:id])
  end

  def create
    # HACK: use upload action instead... create isn't working for some reason
  end
  
  def upload
    @upload = Upload.new(params[:upload])
    @upload.user_id = current_user.id
    respond_to do |format|
      if @upload.save
        flash[:notice] = 'Upload was successfully created.'
        format.html { redirect_to upload_url(@upload) }
        format.xml  { head :created, :location => upload_url(@upload) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @upload.errors.to_xml }
      end
    end
  end

  def update
    @upload = Upload.find(params[:id])
    respond_to do |format|
      if @upload.update_attributes(params[:upload])
        flash[:notice] = 'Upload was successfully updated.'
        format.html { redirect_to upload_url(@upload) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @upload.errors.to_xml }
      end
    end
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
