class TopicsController < ApplicationController
  
  before_filter :force_login, :except => [:index, :show, :unknown_request]
  before_filter :can_edit_topic, :only => [:edit, :update, :destroy]
  before_filter :check_privacy, :only => [:show]
  
  def index
    @topic = Topic.new
    if logged_in?
      @topics = Topic.find(:all, :include => [:user, :last_poster], :limit => 50, :order => 'last_post_at desc')
    else
      @topics = Topic.find(:all, :include => [:user, :last_poster], :limit => 50, :order => 'last_post_at desc', :conditions => ["private = ?", false])
    end
  end

  def show
    @topic = Topic.find(params[:id], :include => :forum)
    @posts = @topic.posts.find(:all, :include => :user)
    @posters = @posts.map(&:user) ; @posters.uniq!
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
    redirect_to login_path unless logged_in?
    @topics = Topic.find(:all, :include => [:user, :last_poster], :order => 'last_post_at desc', :conditions => ["last_post_at > ?", current_user.last_login_at])
    render(:template => "topics/index")
  end
    
  def unknown_request
    if request.request_uri.include?('viewtopic.php')
      redirect_to topic_path(:id => params[:pid], :anchor => params[:anchor])
    elsif request.request_uri.include?('show_new')
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
