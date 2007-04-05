class AdminController < ApplicationController
  
  before_filter :check_admin 
  
  def index
  end
  
  def themes
    @themes = Theme.find(:all)
    render :template => 'themes/index'
  end
    
end
