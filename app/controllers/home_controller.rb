class HomeController < ApplicationController  
  
  def index
    if logged_in?
      @topics = Topic.paginate(:page => params[:page], :per_page => 10, :include => [:user, :forum, :last_poster], :order => 'topics.last_post_at desc')
      @date = Time.parse("#{params[:date]} || TzTime.now")
      @events = Event.paginate(:page => params[:page], :per_page => Topic::PER_PAGE, :order => 'updated_at desc')
    else
      render(:template => "users/login")
    end
  end
  
end
