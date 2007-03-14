class HomeController < ApplicationController  
  
  def index
    @user_count = User.count
    @topics_count = Topic.count
    @posts_count = Post.count
    @newest_user = User.find(:first, :order => "created_at desc")
  end
  
end
