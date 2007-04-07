class SearchController < ApplicationController

  def index
    if !request.post?
      render :template => "search/index"
    else
      @topics = Topic.find(:all, :include => [:user, :last_poster], :order => 'last_post_at desc')
      render :template => "topics/index"
    end
  end
  
end
