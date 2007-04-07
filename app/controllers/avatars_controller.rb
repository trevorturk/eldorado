class AvatarsController < ApplicationController
  
  before_filter :redirect_to_home, :only => [:show, :edit, :update]
  before_filter :force_login, :except => [:index]
  
  def index
    @avatars = Avatar.find(:all, :order => 'updated_at desc')
  end

  def new
    @avatar = Avatar.new
    render :template => "avatars/_new"
  end

  def create
    @avatar = current_user.avatars.build params[:avatar]
    if @avatar.save
      redirect_to avatars_path
    else
      render :action => "_new"
    end
  end

  def destroy
    @avatar = Avatar.find(params[:id])
    redirect_to avatars_path and return false unless admin? || (current_user == @avatar.user)
    @user = User.find_by_avatar_id(@avatar.id)
    @user.update_attributes(:avatar_id => nil) if @user 
    @avatar.destroy
    redirect_to avatars_url
  end
  
  def select
    @avatar = Avatar.find(params[:id])
    #check if avatar is already in use
    redirect_to avatars_path and return false unless @avatar.current_user_id.blank?
    # clear the current_user_id info for the user's current avatar
    @old_avatar = Avatar.find_by_current_user_id(current_user.id)
    @old_avatar.update_attributes(:current_user_id => nil) if @old_avatar
    # set the current_user_id for the new avatar
    @avatar.update_attributes(:current_user_id => current_user.id)
    # set the new avatar_id for the current user
    current_user.update_attributes(:avatar_id => @avatar.id)
    redirect_to user_path(current_user)
  end
  
  def deselect
    @avatar = Avatar.find(current_user.avatar_id)
    @avatar.update_attributes(:current_user_id => nil)
    current_user.update_attributes(:avatar_id => nil)
    redirect_to user_path(current_user)
  end
  
end
