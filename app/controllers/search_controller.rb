class SearchController < ApplicationController

  def index
    if !request.post?
      render :template => "search/index"
    else
      @topics = Topic.paginate(:page => params[:page], :include => [:user, :last_poster], :order => 'last_post_at desc')
      render :template => "topics/index"
    end
  end
  
end
