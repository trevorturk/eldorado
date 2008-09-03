class HeadersController < ApplicationController
  
  before_filter :require_login, :except => [:index, :show]
  before_filter :can_edit, :only => [:edit, :update, :destroy]
  
  def index
    @headers = Header.paginate(:page => params[:page], :order => 'created_at desc')
  end

  def show
    @header = Header.find(params[:id])
  end

  def new
  end

  def create
    @header = current_user.headers.build params[:header]
    if @header.save
      redirect_to @header
    else
      render :action => 'new'
    end
  end

  def edit
    @header = Header.find(params[:id])
  end
  
  def update
    @header = Header.find(params[:id])
    if @header.update_attributes(params[:header])
      redirect_to @header
    else
      render :action => 'edit'
    end
  end

  def destroy
    @header = Header.find(params[:id])
    @header.destroy
    redirect_to headers_path
  end
  
  def vote_up
    @header = Header.find(params[:id])
    @header.vote_up
    render :partial => 'votes.html.erb'
  end
  
  def vote_down
    @header = Header.find(params[:id])
    @header.vote_down
    render :partial => 'votes.html.erb'
  end  
end
