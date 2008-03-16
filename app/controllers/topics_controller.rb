class TopicsController < ApplicationController
  
  before_filter :require_login, :except => [:index, :show, :show_new, :unknown_request]
  before_filter :can_edit, :only => [:edit, :update, :destroy]
  
  def index
    @topics = Topic.paginate(:page => params[:page], :include => [:user, :last_poster], :order => 'last_post_at desc')
  end
  
  def show
    @topic = Topic.find(params[:id], :include => :forum)
    @posts = @topic.posts.paginate(:page => params[:page], :include => :user)
    redirect_to @topic if @posts.blank? # if params[:page] is too big, no posts will be found
    @page = params[:page] ? params[:page] : 1
    @padding = ((@page.to_i - 1) * Topic::PER_PAGE) # to get post #s w/ pagination
    @topic.hit!
  end
  
  def new
  end
  
  def create
    @topic = current_user.topics.build(params[:topic])
    @post = @topic.posts.build(params[:topic]) ; @post.user = current_user
    redirect_to @topic and return true if @topic.save && @post.save
    render :action => "new"
  end
  
  def edit
    @topic = Topic.find(params[:id])
  end
  
  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(params[:topic])
      redirect_to @topic
    else
      render :action => "edit"
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy
    redirect_to topics_url
  end
  
  def show_new
    @topic = Topic.find(params[:id])
    @post = @topic.posts.find(:first, :order => 'created_at asc', :conditions => ["created_at >= ?", session[:online_at]]) unless !logged_in?
    @post = Post.find(@topic.last_post_id) if @post.nil?
    redirect_to :controller => 'topics', :action => 'show', :id => @topic.id, :page => @post.page, :anchor => 'p' + @post.id.to_s
  end
    
  def unknown_request
    if request.request_uri.include?('viewtopic.php') # catch punbb-style urls
      if params[:id].blank? # punbb can show a topic based on the post_id being passed as "pid"
        @post = Post.find(params[:pid]) # if this is the case, get the post info
        params[:id] = @post.topic_id # set the regular topic_id value as id with this post's topic_id
      end
      redirect_to topic_path(:id => params[:id], :anchor => params[:anchor]) and return
    elsif request.request_uri.include?('viewforum.php') # legacy url format from punbb for forums
      redirect_to forum_path(:id => params[:id]) and return unless params[:id].blank? 
    elsif request.request_uri.include?('action=show_new') # legacy url format from punbb
      redirect_to topics_path and return
    end
    redirect_to root_path
  end
  
end