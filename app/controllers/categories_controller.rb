class CategoriesController < ApplicationController
  
  before_filter :require_admin, :except => [:index, :show]

  def index
    redirect_to forum_root_path
  end
  
  def show
    @category = Category.find(params[:id], :include => :forums)
    @forums = @category.forums
    @topics = Topic.get(params[:page], 30, ["forum_id in (?)", @forums.collect(&:id)])
    render :template => 'topics/index'
  end
  
  def new
  end
    
  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to forum_root_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @category = Category.find(params[:id])
  end
  
  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      redirect_to @category
    else
      render :action => "edit"
    end
  end
    
  def destroy
    @category = Category.find(params[:id])
    if params[:confirm] != "1"
      flash[:notice] = "You must check the confirmation box"
      redirect_to confirm_delete_category_path(@category)
    else
      @category.destroy
      redirect_to forum_root_path
    end
  end
  
  def confirm_delete
    @category = Category.find(params[:id])
  end
end
