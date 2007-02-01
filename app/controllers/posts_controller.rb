class PostsController < ApplicationController 

  before_filter :find_topic 
  before_filter :force_login 

  def new 
    @post = Post.new 
  end 

  def edit 
    @post = @topic.posts.find(params[:id]) 
  end 

  def create 
    @post = Post.new(params[:post]) 
    @post.user_id = current_user.id
    if (@topic.posts << @post) 
      redirect_to topic_url(@topic) 
    else 
      render :action => :new 
    end 
  end 

  def update 
    @post = @topic.posts.find(params[:id]) 
    if @post.update_attributes(params[:post]) 
      redirect_to topic_url(@topic) 
    else 
      render :action => :edit 
    end 
  end 

  def destroy 
    post = @topic.posts.find(params[:id].to_i) 
    @topic.posts.delete(post) 
    redirect_to topic_url(@topic) 
  end 

  private 

  def find_topic 
    @topic_id = params[:topic_id] 
    redirect_to topics_url unless @topic_id 
    @topic = Topic.find(@topic_id) 
  end 
  
end
