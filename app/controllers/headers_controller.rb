class HeadersController < ApplicationController
  
  before_filter :force_login, :except => [:index, :show]
  before_filter :can_edit_header, :only => [:edit, :update, :destroy]
  
  def index
    @headers = Header.find(:all, :order => 'created_at desc')
    @headers_count = Header.count
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @headers.to_xml }
    end
  end

  def show
    @header = Header.find(params[:id])
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @header.to_xml }
    end
  end

  def new
    @header = Header.new
  end

  def edit
    @header = Header.find(params[:id])
  end

  def create
    @header = Header.new(params[:header])
    @header.user_id = current_user.id
    respond_to do |format|
      if @header.save
        format.html { redirect_to header_url(@header) }
        format.xml  { head :created, :location => header_url(@header) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @header.errors.to_xml }
      end
    end
  end
  
  def update
    @header = Header.find(params[:id])
    respond_to do |format|
      if @header.update_attributes(params[:header])
        format.html { redirect_to header_url(@header) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @header.errors.to_xml }
      end
    end
  end

  def destroy
    @header = Header.find(params[:id])
    @header.destroy
    respond_to do |format|
      format.html { redirect_to headers_url }
      format.xml  { head :ok }
    end
  end
  
  def can_edit_header
    @header = Header.find(params[:id])
    redirect_to header_path(@header) and return false unless admin? || (current_user == @header.user)
  end
  
end
