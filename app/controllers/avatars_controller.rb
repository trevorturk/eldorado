class AvatarsController < ApplicationController

  before_filter :force_login, :except => [:index, :show]
  
  def index
    @avatars = Avatar.find(:all, :order => 'updated_at')
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @avatars.to_xml }
    end
  end

  def show
    @avatar = Avatar.find(params[:id])
  end

  def new
    @avatar = Avatar.new
  end

  def edit
    @avatar = Avatar.new
  end

  def create
    @avatar = current_user.avatars.build params[:avatar]
    respond_to do |format|
      if @avatar.save
        flash[:notice] = 'Avatar was successfully created.'
        format.html { redirect_to avatars_path }
        format.xml  { head :created, :location => avatars_path }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @avatar.errors.to_xml }
      end
    end
  end

  def update
    redirect_to avatars_path
  end

  def destroy
    @avatar = Avatar.find(params[:id])
    redirect_to avatars_path and return false unless admin? || (current_user == @avatar.user)
    @avatar.destroy
    respond_to do |format|
      format.html { redirect_to avatars_url }
      format.xml  { head :ok }
    end
  end
  
  def select
    @avatar = Avatar.find(params[:id])
    # To-Do check that avatar is not in user by another user
    @avatar.update_attributes(:current_user_id => current_user.id)
    current_user.update_attributes(:avatar_id => @avatar.id)
    redirect_to avatars_path
  end
  
end
