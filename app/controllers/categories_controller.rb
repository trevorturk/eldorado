class CategoriesController < ApplicationController
  
  before_filter :redirect_to_home, :except => [:show]
    
  def show
    @category = Category.find(params[:id], :include => :forums)
    @forums = @category.forums
    if logged_in?
      @topics = Topic.find(:all, :include => [:user, :forum, :last_poster], :order => 'topics.last_post_at desc', :conditions => ["forum_id in (?)", @forums.collect(&:id)])
    else
      @topics = Topic.find(:all, :include => [:user, :forum, :last_poster], :order => 'topics.last_post_at desc', :conditions => ["forum_id in (?) and private = ?", @forums.collect(&:id), false])
    end
    render(:template => "topics/index")
  end
    
end
