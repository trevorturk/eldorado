class PostsController < ApplicationController 
  
  before_filter :find_parent_user_or_class, :only => [:index]
  before_filter :find_topic_and_post, :except => [:index, :new, :create]
  before_filter :require_login, :except => [:index, :show, :topic]
  before_filter :can_edit, :only => [:edit, :update, :destroy]
  
  def index
    @posts = @parent.get(params[:page])
    render :template => 'topics/show'
  end
  
  def show
    @post = Post.find(params[:id])
  end
  
  def new
  end

  def create
    @topic = Topic.find(params[:post][:topic_id])
    redirect_to root_path and return false unless @topic
    @post = current_user.posts.build(params[:post])
    if @topic.locked
      redirect_to root_path and return false unless admin? || (current_user == @topic.user) # TODO can this be a conditional before_filter?
    end
    @topic.posts_count += 1 # hack to set last_page correctly
    if (@topic.posts << @post) 
      redirect_to :controller => 'topics', :action => 'show', :id => @topic.id, :page => @topic.last_page, :anchor => 'p' + @post.id.to_s
    else 
      flash[:notice] = "Posts cannot be blank"
      redirect_to @topic
    end 
  end
  
  def edit
  end 
    
  def update 
    @post.updated_by = current_user.id
    if @post.update_attributes(params[:post]) 
      redirect_to topic_post_path(@post)
    else 
      render :action => 'edit'
    end 
  end 

  def destroy 
    @post.destroy if @topic.posts_count > 1
    redirect_to show_new_topic_path(@topic)
  end 
  
  def topic
    redirect_to :controller => 'topics', :action => 'show', :id => @topic.id, :page => @post.page, :anchor => 'p' + @post.id.to_s
  end
  
  def quote
    @body = "[quote=#{@post.user.login}]#{@post.body}[/quote]"
    @post = nil # clear post so form with create a new one
    render :template => 'posts/new'
  end
  
  def find_topic_and_post
    @post = Post.find(params[:id])
    @topic = Topic.find(@post.topic.id)
    redirect_to topics_path unless @topic
  end
end
