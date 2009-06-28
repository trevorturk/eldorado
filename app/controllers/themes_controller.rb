class ThemesController < ApplicationController
  
  before_filter :redirect_home, :only => [:show, :edit, :update]
  before_filter :require_admin
  
  def index
    @themes = Theme.paginate(:page => params[:page])
    @current_theme = Setting.current_theme
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
    @settings.update_attributes(:theme => nil) if @settings.theme == @theme.attachment_file_name
    @theme.destroy
    redirect_to themes_path
  end
  
  def select
    @theme = Theme.find(params[:id])
    @theme.select
    redirect_to themes_path
  end
  
  def deselect
    @theme = Theme.find(params[:id])
    @theme.deselect
    redirect_to themes_path
  end
  
end
