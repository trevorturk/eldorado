class NewbiesController < ApplicationController
  
  before_filter :check_admin 
  
  def create
    @newbie = Newbie.new(:term => params[:newbie][:term])
    if @newbie.save
      redirect_to admin_path
    else
      flash[:notice] = "Newbie Terms must be less than 25 characters and unique."
      redirect_to admin_path
    end
  end
  
  def destroy
    params[:newbies].each do |n|
      @newbie = Newbie.find_by_id(n)
      @newbie.destroy
    end
    redirect_to admin_path
  end
    
end
