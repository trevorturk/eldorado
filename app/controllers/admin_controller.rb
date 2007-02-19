class AdminController < ApplicationController
  
  before_filter :check_admin 
  
  def index
    @newbies = Newbie.find(:all)
  end
  
  def create_newbie
    @newbie = Newbie.new(:term => params[:admin][:term])
    if @newbie.save
      redirect_to admin_path
    else
      flash[:notice] = "Newbie Terms must be less than 25 characters and unique."
      redirect_to admin_path
    end
  end
  
  def delete_newbies
    @newbies = params[:newbie]
    # delete the newbies
    redirect_to admin_path
  end
  
  def check_admin
    redirect_to home_path and return false unless admin?
  end
  
end
