class HeadersController < ApplicationController
  
  before_filter :force_login, :except => [:index, :show]
  before_filter :can_edit_header, :only => [:edit, :update, :destroy]
  
  def index
    @headers = Header.find(:all, :order => 'created_at desc')
  end

  def show
    @header = Header.find(params[:id])
  end

  def new
    @header = Header.new
    render :template => "headers/_new"
  end

  def edit
    @header = Header.find(params[:id])
  end

  def create
    @header = current_user.headers.build params[:header]
    if @header.save
      redirect_to header_url(@header)
    else
      render :action => "_new"
    end
  end
  
  def update
    @header = Header.find(params[:id])
    if @header.update_attributes(params[:header])
      redirect_to header_url(@header)
    else
      render :action => "edit"
    end
  end

  def destroy
    @header = Header.find(params[:id])
    @header.destroy
    redirect_to headers_url
  end
  
  def vote_up
    @header = Header.find(params[:id])
    @header.vote_up
    render :partial => 'votes'
  end
  
  def vote_down
    @header = Header.find(params[:id])
    @header.vote_down
    render :partial => 'votes'
  end
  
  def can_edit_header
    @header = Header.find(params[:id])
    redirect_to header_path(@header) and return false unless admin? || (current_user == @header.user)
  end
  
end
