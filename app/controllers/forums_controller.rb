class ForumsController < ApplicationController
  
  before_filter :require_admin, :except => [:index, :show]
  
  def index
    @categories = Category.find(:all, :include => [:forums], :order => 'categories.position, forums.position')
    @posts_count = Forum.sum('posts_count')
    @topics_count = Forum.sum('topics_count')
  end

  def show
    @forum = Forum.find(params[:id], :include => :category)
    @topic = Topic.new ; @topic.forum_id = @forum.id # set forum_id for new topic select default option
    if logged_in?
      @topics = Topic.paginate(:page => params[:page], :include => [:user, :last_poster], :order => 'last_post_at desc', :conditions => ["forum_id = ?", @forum.id])
    else
      @topics = Topic.paginate(:page => params[:page], :include => [:user, :last_poster], :order => 'last_post_at desc', :conditions => ["forum_id = ? and private = ?", @forum.id, false])
    end
    render(:template => "topics/index")
  end
  
  def new
    @forum = Forum.new(:category_id => params[:category_id])
  end
  
  def create
    @forum = Forum.new(params[:forum])
    render :action => 'new' and return false unless @forum.save
    redirect_to @forum
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
    redirect_to root_path
  end
     
end
