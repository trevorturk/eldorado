class ForumsController < ApplicationController
  
  before_filter :redirect_home, :only => [:new, :edit, :update, :destroy]
  before_filter :require_admin, :except => [:index, :show]
  
  def index
    @categories = Category.find(:all, :include => [:forums], :order => 'categories.position, forums.position')
  end

  def show
    @forum = Forum.find(params[:id], :include => :category)
    @topic = Topic.new ; @topic.forum_id = @forum.id # set forum_id for new topic select default option
    if logged_in?
      @topics = Topic.paginate(:page => params[:page], :per_page => Topic::PER_PAGE, :include => [:user, :last_poster], :order => 'last_post_at desc', :conditions => ["forum_id = ?", @forum.id])
    else
      @topics = Topic.paginate(:page => params[:page], :per_page => Topic::PER_PAGE, :include => [:user, :last_poster], :order => 'last_post_at desc', :conditions => ["forum_id = ? and private = ?", @forum.id, false])
    end
    render(:template => "topics/index")
  end
    
  def create
    @forum = Forum.new(params[:forum])
    flash[:notice] = "The forum has been created." if @forum.save
    redirect_to :action => :admin
  end
  
  def admin
    @categories = Category.find(:all, :include => [:forums], :order => 'categories.position, forums.position')
  end
   
end
