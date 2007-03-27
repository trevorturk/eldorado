class ForumsController < ApplicationController
  
  before_filter :redirect, :except => [:index, :show]
  
  def index
    @categories = Category.find(:all, :order => 'position asc')
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @categories.to_xml }
    end
  end

  def show
    @forum = Forum.find(params[:id])
    @category = Category.find(@forum.category_id)
    if logged_in?
      @topic_pages, @topics = paginate(:topics, :per_page => 20, :include => [:user, :last_poster], :order => 'last_post_at desc', :conditions => ["forum_id = ?", @forum.id])
    else
      @topic_pages, @topics = paginate(:topics, :per_page => 20, :include => [:user, :last_poster], :order => 'last_post_at desc', :conditions => ["forum_id = ? and private = ?", @forum.id, false])
    end
    respond_to do |format|
      format.html { render(:template => "topics/index") }
      format.xml  { render :xml => @forum.to_xml }
    end
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end
  
  def redirect
    redirect_to home_path
  end
  
end
