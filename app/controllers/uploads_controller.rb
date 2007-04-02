class UploadsController < ApplicationController
  
  before_filter :force_login, :except => [:index, :show]
  
  def index
    if request.post?
      @filter_type = params[:upload][:content_type]
      @filter_user = params[:upload][:user_id]
      if @filter_type != '0'
        @uploads = Upload.find(:all, :order => 'updated_at desc', :conditions => ["content_type = ?", @filter_type])
      elsif @filter_user != '0'
        @uploads = Upload.find(:all, :order => 'updated_at desc', :conditions => ["user_id = ?", @filter_user])
        @filter_user = User.find(@filter_user)
      end
    else
      @uploads = Upload.find(:all, :order => 'updated_at desc')
    end
    @filter_users = Upload.find(:all, :group => 'user_id', :include => [:user])
    @filter_types = Upload.find(:all, :group => 'content_type')
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @uploads.to_xml }
    end
  end

  def show
    redirect_to files_home_path
  end

  def new
    @upload = Upload.new
    render :template => "uploads/_new"
  end

  def edit
    redirect_to files_home_path
  end

  def create
    @upload = current_user.uploads.build params[:upload]
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
    redirect_to files_home_path
  end

  def destroy
    @upload = Upload.find(params[:id])
    redirect_to files_home_path and return false unless admin? || (current_user == @upload.user)
    @upload.destroy
    respond_to do |format|
      format.html { redirect_to files_home_path }
      format.xml  { head :ok }
    end
  end
  
end
