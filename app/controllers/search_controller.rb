class SearchController < ApplicationController
    
  def index
    if params[:type].blank? || params[:query].blank?
      render :template => 'search/index'
    elsif params[:type] == 'articles'
      @articles = Article.title_or_body_like(params[:query]).all(:include => :user, :order => 'articles.created_at desc')
      render :template => 'articles/archives'
    elsif params[:type] == 'avatars'
      @avatars = Avatar.attachment_file_name_like(params[:query]).paginate(:page => params[:page], :include => :user, :order => 'avatars.created_at desc')
      render :template => 'avatars/index'
    elsif params[:type] == 'events'
      @events = Event.title_or_description_like(params[:query]).paginate(:page => params[:page], :include => :user, :order => 'events.created_at desc')
      render :template => 'events/index'
    elsif params[:type] == 'files'
      @uploads = Upload.attachment_file_name_like(params[:query]).paginate(:page => params[:page], :include => :user, :order => 'uploads.created_at desc')
      render :template => 'uploads/index'
    elsif params[:type] == 'headers'
      @headers = Header.attachment_file_name_or_description_like(params[:query]).paginate(:page => params[:page], :include => :user, :order => 'headers.created_at desc')
      render :template => 'headers/index'
    elsif params[:type] == 'messages'
      @messages = Message.body_like(params[:query]).paginate(:page => params[:page], :include => :user, :order => 'messages.created_at desc')
      render :template => 'search/messages'
    elsif params[:type] == 'posts'
      @posts = Post.body_like(params[:query]).paginate(:page => params[:page], :include => :user, :order => 'posts.created_at desc')
      render :template => 'topics/show'
    elsif params[:type] == 'topics'
      @topics = Topic.title_like(params[:query]).paginate(:page => params[:page], :include => [:user, :forum, :last_poster, :viewings], :order => 'topics.last_post_at desc')    
      render :template => 'topics/index'
    elsif params[:type] == 'users'
      @users = User.login_or_bio_or_signature_like(params[:query]).paginate(:page => params[:page], :order => 'created_at desc')        
      render :template => 'users/index'
    end
  end  
end
