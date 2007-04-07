class TopicsController < ApplicationController
  
  before_filter :force_login, :except => [:index, :show, :unknown_request]
  before_filter :can_edit_topic, :only => [:edit, :update, :destroy]
  before_filter :check_privacy, :only => [:show]
  
  def index
    if logged_in?
      @topics = Topic.find(:all, :include => [:user, :last_poster], :order => 'last_post_at desc')
    else
      @topics = Topic.find(:all, :include => [:user, :last_poster], :order => 'last_post_at desc', :conditions => ["private = ?", false])
    end
  end

  def show
    @topic = Topic.find(params[:id])
    @posts = @topic.posts.find(:all)
    @forum = Forum.find_by_id(@topic.forum_id)
    @category = Category.find(@forum.category_id)
    @topic.hit!
    @page_title = @topic.title
    @posters = @posts.map(&:user) ; @posters.uniq!
  end

  def new
    @topic = Topic.new
    @topic.forum_id = params[:forum_id] 
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def create
    @topic = Topic.new(params[:topic])
    if @topic
      @topic.user_id = current_user.id
      @post = @topic.posts.build(params[:topic])
      @post.user_id = current_user.id
    end
    if @topic.save && @post.save
      redirect_to topic_url(@topic)
    else
      render :action => "new"
    end
  end

  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(params[:topic])
      redirect_to topic_url(@topic)
    else
      render :action => "edit"
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy
    redirect_to topics_url
  end
    
  def unknown_request
    if request.request_uri.include?('viewtopic.php')
      redirect_to topic_path(:id => params[:id])
    else
      redirect_to topics_path
    end
  end
  
  def can_edit_topic
    @topic = Topic.find(params[:id])
    redirect_to topic_path(@topic) and return false unless admin? || (current_user == @topic.user)
  end
  
  def check_privacy
    @topic = Topic.find(params[:id])
    redirect_to login_path if (!logged_in? && @topic.private)
  end
  
end
