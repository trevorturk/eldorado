class ForumsController < ApplicationController
  
  before_filter :require_admin, :except => [:index, :show]
  
  def index
    @categories = Category.find(:all, :include => [:forums], :order => 'categories.position, forums.position')
    @posts_count = Forum.sum('posts_count')
    @topics_count = Forum.sum('topics_count')
  end

  def show
    @forum = Forum.find(params[:id], :include => :category)
    @topics = @forum.topics.paginate(:page => params[:page], :include => [:user, :last_poster], :order => 'sticky desc, last_post_at desc')
    render :template => 'topics/index'
  end
  
  def new
    @forum = Forum.new(:category_id => params[:category_id])
    redirect_to new_category_path if Category.count == 0
  end
  
  def create
    @forum = Forum.new(params[:forum])
    if @forum.save
      redirect_to @forum
    else
      render :action => 'new'
    end
  end
  
  def edit
    @forum = Forum.find(params[:id])
  end
  
  def update
    @forum = Forum.find(params[:id])
    if @forum.update_attributes(params[:forum])
      redirect_to @forum
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @forum = Forum.find(params[:id])
    if params[:confirm] != "1"
      flash[:notice] = "You must check the confirmation box"
      redirect_to confirm_delete_forum_path(@forum)
    else
      @forum.destroy
      redirect_to forum_root_path
    end
  end
  
  def confirm_delete
    @forum = Forum.find(params[:id])
  end
end
