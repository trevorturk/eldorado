class SearchController < ApplicationController
  
  before_filter :force_login
  
  def index
    if request.post?
      @topics = Topic.paginate(:page => params[:page], :include => [:user, :last_poster], :order => 'last_post_at desc', :conditions => ["title LIKE ?", '%' + params[:q] + '%'])
      render :template => "topics/index"
    else
      render :template => "search/index"
    end
  end
  
end
