class CategoriesController < ApplicationController
  
  before_filter :redirect_to_home, :except => [:show]
    
  def show
    @category = Category.find(params[:id], :include => :forums)
    @forums = @category.forums
    if logged_in?
      @topic_pages, @topics = paginate(:topics, :per_page => 20, :include => [:user, :last_poster], :order => 'last_post_at desc', :conditions => ["forum_id in (?)", @forums.collect(&:id)])
    else
      @topic_pages, @topics = paginate(:topics, :per_page => 20, :include => [:user, :last_poster], :order => 'last_post_at desc', :conditions => ["forum_id in (?) and private = ?", @forums.collect(&:id), false])
    end
    render(:template => "topics/index")
  end
    
end
