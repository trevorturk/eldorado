class MessagesController < ApplicationController
  
  before_filter :redirect_home, :only => [:show, :new, :edit, :update]
  before_filter :require_login, :only => [:new, :create]
  before_filter :can_edit, :only => [:destroy]
  skip_filter   :update_online_at, :get_newest_user, :auth_token_login, :check_bans, :get_reminders, :only => [:refresh]
  
  def index
    session[:refresh_messages] ||= Time.now
    @messages = Message.find(:all, :limit => 7, :include => [:user], :order => 'messages.created_at desc')
  end
  
  def create
    @message = current_user.messages.build(params[:message])
    render :nothing => true and return if @message.save
    redirect_to chat_path
  end
  
  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    redirect_to chat_path
  end
  
  def refresh
    @messages = Message.find(:all, :order => 'created_at desc', :conditions => ['created_at >= ?', session[:refresh_messages]])
    session[:refresh_messages] = Time.now
    if @messages
      render :update do |page|
        page.insert_html :top, 'messages-index', :partial => 'messages', :object => @messages
      end
    end
  end
  
end
