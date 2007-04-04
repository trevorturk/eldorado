class ForumsController < ApplicationController
  
  before_filter :redirect_to_home, :except => [:index, :show]
  
  def index
    @categories = Category.find(:all, :include => :forums, :order => 'categories.position, forums.position')
  end

  def show
    @forum = Forum.find(params[:id])
    @category = Category.find(@forum.category_id)
    if logged_in?
      @topic_pages, @topics = paginate(:topics, :per_page => 20, :include => [:user, :last_poster], :order => 'last_post_at desc', :conditions => ["forum_id = ?", @forum.id])
    else
      @topic_pages, @topics = paginate(:topics, :per_page => 20, :include => [:user, :last_poster], :order => 'last_post_at desc', :conditions => ["forum_id = ? and private = ?", @forum.id, false])
    end
    render(:template => "topics/index")
  end
 
end
