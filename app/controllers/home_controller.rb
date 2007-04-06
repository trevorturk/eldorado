class HomeController < ApplicationController  
  
  def index
    if logged_in?
      @topic_pages, @topics = paginate(:topics, :per_page => 6, :include => [:user, :forum, :last_poster], :order => 'topics.last_post_at desc')
      render(:template => "topics/index")
    else
      render(:template => "users/login")
    end
  end
  
end
