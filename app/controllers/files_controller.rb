class FilesController < ApplicationController
  # GET /files
  # GET /files.xml
  def index
    @files = Files.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @files.to_xml }
    end
  end

  # GET /files/1
  # GET /files/1.xml
  def show
    @files = Files.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @files.to_xml }
    end
  end

  # GET /files/new
  def new
    @files = Files.new
  end

  # GET /files/1;edit
  def edit
    @files = Files.find(params[:id])
  end

  # POST /files
  # POST /files.xml
  def create
    @files = Files.new(params[:files])

    respond_to do |format|
      if @files.save
        flash[:notice] = "yes"
        format.html { redirect_to files_url(@files) }
        format.xml  { head :created, :location => files_url(@files) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @files.errors.to_xml }
      end
    end
  end

  # PUT /files/1
  # PUT /files/1.xml
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

  # DELETE /files/1
  # DELETE /files/1.xml
  def destroy
    @files = Files.find(params[:id])
    @files.destroy

    respond_to do |format|
      format.html { redirect_to :controller => 'files' }
      format.xml  { head :ok }
    end
  end
end
