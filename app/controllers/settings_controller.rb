class SettingsController < ApplicationController

  before_filter :redirect_home, :except => [:index, :update]
  before_filter :require_admin
  
  def index
    @settings = Setting.find(:first)
  end
  
  def update 
    @setting = Setting.find(params[:id])
    @setting.update_attributes(params[:setting]) 
    redirect_to settings_path
  end

end
