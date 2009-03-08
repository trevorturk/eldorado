class HomeController < ApplicationController  
  
  def index
    @date = Time.parse("#{params[:date]} || Time.now.utc")
    @avatars = Avatar.find(:all, :limit => 3, :include => :user, :order => 'avatars.updated_at desc')
    @message = Message.last
    @chatters = User.chatting
    @events = Event.find(:all, :conditions => ['date between ? and ?', @date.strftime("%Y-%m") + '-01', @date.next_month.strftime("%Y-%m") + '-01'])
    @headers = Header.find(:all, :limit => 3, :include => :user, :order => 'headers.created_at desc')
    @topics = Topic.get(1, 20)
    @uploads = Upload.find(:all, :limit => 5, :include => :user, :order => 'uploads.updated_at desc')
    @users = User.find(:all, :limit => 3, :order => 'profile_updated_at desc')
  end
  
  def help
  end
  
end
