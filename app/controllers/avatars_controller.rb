class AvatarsController < ApplicationController
  
  before_filter :redirect_home, :only => [:show, :edit, :update]
  before_filter :require_login, :except => [:index]
  before_filter :can_edit, :only => [:destroy]
  
  def index
    @avatars = Avatar.paginate(:page => params[:page], :order => 'updated_at desc')
  end
  
  def new
  end
  
  def create
    @avatar = current_user.avatars.build(params[:avatar])
    if @avatar.save
      redirect_to avatars_path
    else
      render :action => "new"
    end
  end
  
  def destroy
    @avatar = Avatar.find(params[:id])
    @avatar.destroy
    redirect_to avatars_path
  end
  
  def select
    @avatar = Avatar.find(params[:id])
    redirect_to avatars_path and return false unless @avatar.current_user_id.blank?
    @old_avatar = Avatar.find_by_current_user_id(current_user.id)
    @old_avatar.update_attributes(:current_user_id => nil) if @old_avatar
    @avatar.update_attributes(:current_user_id => current_user.id)
    current_user.update_attributes(:avatar => @avatar.public_filename)
    redirect_to current_user
  end
  
  def deselect
    @avatar = Avatar.find(params[:id])
    redirect_to avatars_path and return false unless @avatar.current_user_id
    @avatar = Avatar.find_by_current_user_id(current_user.id)
    @avatar.update_attributes(:current_user_id => nil)
    current_user.update_attributes(:avatar => nil)
    redirect_to current_user
  end
end
