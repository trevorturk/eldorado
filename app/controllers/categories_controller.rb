class CategoriesController < ApplicationController
  
  before_filter :require_admin, :except => [:index, :show]

  def index
    redirect_to forum_root_path
  end
  
  def show
    @category = Category.find(params[:id], :include => :forums)
    @forums = @category.forums
    if logged_in?
      @topics = Topic.paginate(:page => params[:page], :include => [:user, :forum, :last_poster], :order => 'topics.last_post_at desc', :conditions => ["forum_id in (?)", @forums.collect(&:id)])
    else
      @topics = Topic.paginate(:page => params[:page], :include => [:user, :forum, :last_poster], :order => 'topics.last_post_at desc', :conditions => ["forum_id in (?) and private = ?", @forums.collect(&:id), false])
    end
    render(:template => "topics/index")
  end
  
  def new
  end
    
  def create
    @category = Category.new(params[:category])
    render :action => 'new' and return false unless @category.save
    redirect_to forum_root_path
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
    redirect_to forum_root_path
  end
    
end
