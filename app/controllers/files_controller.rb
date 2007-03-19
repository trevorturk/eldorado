class FilesController < ApplicationController

  def index
    @files = Files.find(:all)
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @files.to_xml }
    end
  end

  def show
    @files = Files.find(params[:id])
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @files.to_xml }
    end
  end

  def new
    @files = Files.new
  end

  def edit
    @files = Files.find(params[:id])
  end

  def create
  end
  
  def upload
    @files = Files.new(params[:files])
    respond_to do |format|
      if @files.save
        format.html { redirect_to :controller => "files" }
        format.xml  { head :created, :location => files_url(@files) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @files.errors.to_xml }
      end
    end
  end

  def update
    @files = Files.find(params[:id])
    respond_to do |format|
      if @files.update_attributes(params[:files])
        format.html { redirect_to files_url(@files) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @files.errors.to_xml }
      end
    end
  end

  def destroy
    @files = Files.find(params[:id])
    @files.destroy
    respond_to do |format|
      format.html { redirect_to :controller => 'files' }
      format.xml  { head :ok }
    end
  end
end
