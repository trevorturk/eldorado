class CategoriesController < ApplicationController
  
  before_filter :redirect, :except => [:show]
    
  def show
    @category = Category.find(params[:id])
    @forums = Forum.find_all_by_category_id(@category.id)
    if logged_in?
      @topic_pages, @topics = paginate(:topics, :per_page => 20, :include => [:user, :last_poster], :order => 'last_post_at desc', :conditions => ["forum_id in (?)", @forums.collect(&:id)])
    else
      @topic_pages, @topics = paginate(:topics, :per_page => 20, :include => [:user, :last_poster], :order => 'last_post_at desc', :conditions => ["forum_id in (?) and private = ?", @forums.collect(&:id), false])
    end
    respond_to do |format|
      format.html { render(:template => "topics/index") }
      format.xml  { render :xml => @category.to_xml }
    end
  end
  
  def redirect
    redirect_to home_path
  end
        
end
