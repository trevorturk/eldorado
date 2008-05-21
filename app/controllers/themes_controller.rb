class ThemesController < ApplicationController
  
  before_filter :redirect_home, :only => [:show, :edit, :update]
  before_filter :require_admin
  
  def index
    @themes = Theme.paginate(:page => params[:page])
    @current_theme = Theme.find_by_filename(@settings.theme) unless @settings.theme.blank?
  end

  def new
  end

  def create
    @theme = current_user.themes.build(params[:theme])
    if @theme.save
      redirect_to themes_path
    else
      render :action => 'new'
    end
  end

  def destroy
    @theme = Theme.find(params[:id])
    @settings.update_attributes(:theme => nil) if @settings.theme == @theme.filename
    @theme.destroy
    redirect_to themes_path
  end
  
  def select
    @theme = Theme.find(params[:id])
    @settings.update_attributes(:theme => @theme.filename)
    redirect_to themes_path
  end
  
  def deselect
    @settings.update_attributes(:theme => nil)
    redirect_to themes_path
  end
end
