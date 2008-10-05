class TopicsController < ApplicationController
  
  before_filter :require_login, :except => [:index, :show, :show_new, :unknown_request]
  before_filter :can_edit, :only => [:edit, :update, :destroy]
  before_filter :clean_params, :only => [:create, :update]
  
  def index
    @topics = Topic.get(params[:page])
  end
  
  def show
    @topic = Topic.find(params[:id], :include => :forum)
    @posts = @topic.posts.paginate(:page => params[:page], :include => :user)
    redirect_to @topic if @posts.blank? # if params[:page] is too big, no posts will be found
    @page = params[:page] ? params[:page] : 1
    @padding = ((@page.to_i - 1) * 30) # to get post #s w/ pagination
    @topic.viewed_by(current_user) if logged_in?
    @topic.hit!
  end
  
  def new
  end
  
  def create
    @topic = current_user.topics.build(params[:topic])
    @post = @topic.posts.build(params[:topic]) ; @post.user = current_user
    if @topic.save && @post.save
      redirect_to @topic
    else
      render :action => 'new'
    end
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
    redirect_to topics_path
  end
  
  def show_new
    @topic = Topic.find(params[:id])
    last_post = @topic.posts.last
    if logged_in?
      viewing = Viewing.first(:conditions => ['user_id = ? and topic_id = ?', current_user.id, @topic.id])
      if current_user.all_viewed_at > @topic.updated_at # (1) no new posts since user marked all as viewed; view last post
        post = last_post
      elsif viewing.nil? # (2) user never viewed topic before; view first since all viewed at
        post = @topic.posts.first(:conditions => ["created_at >= ?", current_user.all_viewed_at])
      elsif viewing.updated_at > @topic.updated_at # (3) user has viewed topic but there are no newer posts; view last post
        post = last_post
      else # (4) user viewed topic and there are newer posts; view post >= last view of topic
        post = @topic.posts.first(:conditions => ["created_at >= ?", viewing.updated_at])
      end
    else
      post = last_post # (0) not logged in; view last post
    end
    redirect_to "/topics/#{@topic.id}?page=#{post.page}#p#{post.id}"
  end
  
  def mark_all_viewed
    current_user.update_attribute(:all_viewed_at, Time.now)
    flash[:notice] = "All topics marked as read"
    redirect_to forum_root_path
  end
  
  def clean_params
    params[:topic][:sticky] = false unless admin?
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
