class SettingsController < ApplicationController

  before_filter :redirect_home, :except => [:index, :update]
  before_filter :require_admin
  
  def index
    @settings = Setting.find(:first)
  end
    
  def update 
    @setting = Setting.find(params[:id])
    params[:setting][:time_zone] = params[:settings][:time_zone] unless params[:settings].nil? # hack for form plural issue
    @setting.update_attributes(params[:setting])
    redirect_to settings_path
  end
end
