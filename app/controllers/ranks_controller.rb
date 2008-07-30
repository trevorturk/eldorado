class RanksController < ApplicationController
  
  before_filter :redirect_home, :only => [:show]
  before_filter :require_admin, :except => [:index]
  
  def index
    @ranks = Rank.find(:all, :order => 'min_posts asc')
  end
  
  def new
  end
  
  def create
    @rank = Rank.new(params[:rank])
    if @rank.save
      redirect_to ranks_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @rank = Rank.find(params[:id])
  end
  
  def update
    @rank = Rank.find(params[:id])
    if @rank.update_attributes(params[:rank])
      redirect_to ranks_path
    else
      render :action => "edit"
    end
  end
    
  def destroy
    @rank = Rank.find(params[:id])
    @rank.destroy
    redirect_to ranks_path
  end
end
