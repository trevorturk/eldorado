class AdminController < ApplicationController
  
  before_filter :check_admin 
  
  def index
  end
  
  def check_admin
    redirect_to home_path and return false unless admin?
  end
  
end
