class SearchController < ApplicationController

  def index
    if request.post?
      @topics = Topic.find(:all, :include => [:user, :last_poster], :order => 'last_post_at desc')
      render :template => "topics/index"
    else
      render :template => "home/search"
    end
  end
  
end
