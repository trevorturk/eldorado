class ThemesController < ApplicationController
  
  before_filter :redirect_home, :only => [:show, :edit, :update]
  before_filter :require_admin 
  
  def index
    @themes = Theme.paginate(:page => params[:page], :per_page => Topic::PER_PAGE)
    @current_theme = Theme.find(@options.theme_id) unless @options.theme_id.nil?
  end

  def new
  end

  def create
    @theme = current_user.themes.build params[:theme]
    if @theme.save
      redirect_to themes_path
    else
      render :action => "new"
    end
  end

  def destroy
    @theme = Theme.find(params[:id])
    redirect_to themes_path and return false unless can_edit?(@theme)
    @options.update_attributes(:theme_id => nil) if @options.theme_id == @theme.id
    @theme.destroy
    redirect_to themes_path
  end
  
  def select
    @theme = Theme.find(params[:id])
    @options.update_attributes(:theme_id => @theme.id)
    redirect_to themes_path
  end
  
  def deselect
    @options.update_attributes(:theme_id => nil)
    redirect_to themes_path
  end
  
end
