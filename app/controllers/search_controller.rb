class SearchController < ApplicationController
    
  def index
    if params[:type].blank? || params[:query].blank?
      render :template => 'search/index'
    elsif params[:type] == 'articles'
      @articles = Article.all(:include => :user, :order => 'created_at desc', :conditions => ['title LIKE ? OR body LIKE ?', '%'+params[:query]+'%', '%'+params[:query]+'%'])
      render :template => 'articles/archives'
    elsif params[:type] == 'avatars'
      @avatars = Avatar.paginate(:page => params[:page], :include => :user, :order => 'avatars.created_at desc', :conditions => ['filename LIKE ?', '%' + params[:query] + '%'])        
      render :template => 'avatars/index'
    elsif params[:type] == 'events'
      @events = Event.paginate(:page => params[:page], :include => :user, :order => 'events.created_at desc', :conditions => ['title LIKE ?', '%' + params[:query] + '%'])        
      render :template => 'events/index'
    elsif params[:type] == 'files'
      @uploads = Upload.paginate(:page => params[:page], :include => :user, :order => 'uploads.created_at desc', :conditions => ['filename LIKE ?', '%' + params[:query] + '%'])        
      render :template => 'uploads/index'
    elsif params[:type] == 'headers'
      @headers = Header.paginate(:page => params[:page], :include => :user, :order => 'headers.created_at desc', :conditions => ['filename LIKE ?', '%' + params[:query] + '%'])        
      render :template => 'headers/index'
    elsif params[:type] == 'messages'
      @messages = Message.paginate(:page => params[:page], :include => :user, :order => 'messages.created_at desc', :conditions => ['body LIKE ?', '%' + params[:query] + '%'])        
      render :template => 'search/messages'
    elsif params[:type] == 'posts'
      @posts = Post.paginate(:page => params[:page], :include => [:user, :topic], :order => 'posts.created_at desc', :conditions => ['body LIKE ?', '%' + params[:query] + '%'])        
      render :template => 'topics/show'
    elsif params[:type] == 'topics'
      @topics = Topic.paginate(:page => params[:page], :include => [:user, :last_poster], :order => 'sticky desc, last_post_at desc', :conditions => ['title LIKE ?', '%' + params[:query] + '%'])
      render :template => 'topics/index'
    elsif params[:type] == 'users'
      @users = User.paginate(:page => params[:page], :order => 'created_at desc', :conditions => ['login LIKE ?', '%' + params[:query] + '%'])        
      render :template => 'users/index'
    end
  end  
end
