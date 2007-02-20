class AdminController < ApplicationController
  
  before_filter :check_admin 
  
  def index
    @newbies = Newbie.find(:all, :order => 'term')
  end
    
end
