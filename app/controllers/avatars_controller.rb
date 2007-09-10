class AvatarsController < ApplicationController
  
  before_filter :redirect_to_home, :only => [:show, :edit, :update]
  before_filter :force_login, :except => [:index]
  
  def index
    @avatars = Avatar.paginate(:page => params[:page], :per_page => Topic::PER_PAGE, :order => 'updated_at desc')
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
    redirect_to home_path and return false unless admin? || (current_user == @avatar.user)
    @user = User.find_by_id(@avatar.current_user_id)
    @user.update_attributes(:avatar => nil) if @user 
    @avatar.destroy
    redirect_to avatars_url
  end
  
  def select
    @avatar = Avatar.find(params[:id])
    redirect_to avatars_path and return false unless @avatar.current_user_id.blank?
    @old_avatar = Avatar.find_by_current_user_id(current_user.id)
    @old_avatar.update_attributes(:current_user_id => nil) if @old_avatar
    @avatar.update_attributes(:current_user_id => current_user.id)
    current_user.update_attributes(:avatar => @avatar.public_filename)
    redirect_to user_path(current_user)
  end
  
  def deselect
    @avatar = Avatar.find_by_current_user_id(current_user.id)
    @avatar.update_attributes(:current_user_id => nil)
    current_user.update_attributes(:avatar => nil)
    redirect_to user_path(current_user)
  end
  
end
