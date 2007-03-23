class PostsController < ApplicationController 

  before_filter :find_topic_and_post, :except => [:index, :new, :create]
  before_filter :force_login 
  before_filter :can_edit_post, :only => [:edit, :update, :destroy]
  
  def index
    redirect_to home_path
  end
  
  def show
    redirect_to home_path
  end

  def new
    redirect_to home_path
  end
  
  def edit
  end 
    
  def create 
    @post = Post.new(params[:post])
    @post.user_id = current_user.id
    @topic = Topic.find(params[:post][:topic_id])
    if (@topic.posts << @post) 
      Topic.update_all(['last_post_id = ?, last_post_at = ?, last_post_by = ?', @post.id, @post.created_at, @post.user_id], ['id = ?', @topic.id])
      Forum.update_all(['last_post_id = ?, last_post_at = ?, last_post_by = ?', @post.id, @post.created_at, @post.user_id], ['id = ?', @topic.forum_id])
      redirect_to topic_path(@topic) 
    else 
      flash[:notice] = "Posts cannot be blank"
      redirect_to topic_path(@topic)
    end 
  end 

  def update 
    @post.updated_by = current_user.id
    if @post.update_attributes(params[:post]) 
      redirect_to topic_url(@topic) 
    else 
      render :action => :edit 
    end 
  end 

  def destroy 
    @post.destroy
    redirect_to topic_url(@topic) 
  end 
  
  private
  
  def find_topic_and_post
    @post = Post.find(params[:id])
    @topic = Topic.find(@post.topic.id)
    redirect_to topics_url unless @topic
  end 
  
  def can_edit_post
    redirect_to topic_path(@topic) and return false unless admin? || (current_user == @post.user)
  end
  
end
