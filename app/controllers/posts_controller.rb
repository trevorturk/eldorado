class PostsController < ApplicationController 
  
  before_filter :find_topic_and_post, :except => [:new, :create]
  before_filter :require_login, :except => [:show, :locate]
  before_filter :can_edit_post, :only => [:edit, :update, :destroy]
  
  def index
    redirect_to topics_path
  end
  
  def show
    @posts = Post.find_all_by_id(params[:id])
    render :template => "posts/_post"
  end
  
  def new
  end
  
  def edit
  end 
    
  def create
    @topic = Topic.find(params[:post][:topic_id])
    redirect_to root_path and return false unless @topic
    @post = current_user.posts.build(params[:post])
    if @topic.locked
      redirect_to root_path and return false unless admin? || (current_user == @topic.user)
    end
    @topic.posts_count += 1 # hack to set last_page correctly
    if (@topic.posts << @post) 
      redirect_to :controller => 'topics', :action => 'show', :id => @topic.id, :page => @topic.last_page, :anchor => 'p' + @post.id.to_s
    else 
      flash[:notice] = "Posts cannot be blank"
      redirect_to @topic
    end 
  end 

  def update 
    @post.updated_by = current_user.id
    if @post.update_attributes(params[:post]) 
      redirect_to :controller => 'topics', :action => 'show', :id => @topic.id, :page => @post.page, :anchor => 'p' + @post.id.to_s
    else 
      render :action => :edit 
    end 
  end 

  def destroy 
    @post.destroy if @topic.posts_count > 1
    redirect_to @topic
  end 
  
  def locate
    redirect_to :controller => 'topics', :action => 'show', :id => @topic.id, :page => @post.page, :anchor => 'p' + @post.id.to_s
  end
  
  def quote
    @post.body = "[quote=#{@post.user.login}]#{@post.body}[/quote]"
    render :template => "posts/_new"
  end
      
  def find_topic_and_post
    @post = Post.find(params[:id])
    @topic = Topic.find(@post.topic.id)
    redirect_to topics_url unless @topic
  end 
  
  def can_edit_post
    redirect_to root_path and return false unless admin? || (current_user == @post.user)
  end
    
end
