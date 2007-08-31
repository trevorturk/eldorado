class TopicsController < ApplicationController
  
  before_filter :force_login, :except => [:index, :show, :show_posters, :show_new, :unknown_request]
  before_filter :can_edit_topic, :only => [:edit, :update, :destroy]
  before_filter :check_privacy, :only => [:show]
  
  def index
    @topic = Topic.new
    if logged_in?      
      @topics = Topic.paginate(:page => params[:page], :include => [:user, :last_poster], :order => 'last_post_at desc')
    else
      @topics = Topic.paginate(:page => params[:page], :include => [:user, :last_poster], :order => 'last_post_at desc', :conditions => ["private = ?", false])
    end
  end

  def show
    @topic = Topic.find(params[:id])
    @posts = @topic.posts.paginate(:page => params[:page], :per_page => Topic::PER_PAGE, :include => :user)
    @page = params[:page] ? params[:page] : 1
    @padding = ((@page.to_i - 1) * Topic::PER_PAGE) # to get post #s w/ pagination
    @topic.hit!
  end

  def new
    @topic = Topic.new
    @topic.forum_id = params[:forum_id] 
    render :template => "topics/_new"
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
      render :action => "_new"
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
  
  def show_new
    @topic = Topic.find(params[:id])
    @post = @topic.posts.find(:first, :order => 'created_at asc', :conditions => ["created_at >= ?", session[:online_at]]) unless !logged_in?
    @post = Post.find(@topic.last_post_id) if @post.nil?
    redirect_to topic_path(:id => @topic.id, :page => @post.page, :anchor => 'p' + @post.id.to_s)
  end
  
  def show_posters
    @topic = Topic.find(params[:id])
    @posters = @topic.posts.map(&:user) ; @posters.uniq!
    render :update do |page| 
      page.toggle :posters
      page.replace_html 'posters', "#{@posters.map { |u| "#{h u.login}" } * ', ' }" 
    end 
  end
    
  def unknown_request
    if request.request_uri.include?('viewtopic.php') # catch punbb-style urls
      if params[:id].blank? # punbb can show a topic based on the post_id being passed as "pid"
        @post = Post.find(params[:pid]) # if this is the case, get the post info
        params[:id] = @post.topic_id # set the regular topic_id value as id with this post's topic_id
      end
      redirect_to topic_path(:id => params[:id], :anchor => params[:anchor])
    elsif request.request_uri.include?('action=show_new') # legacy url format from punbb
      redirect_to topics_path
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
