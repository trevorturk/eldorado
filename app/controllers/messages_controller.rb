class MessagesController < ApplicationController
  
  before_filter :redirect_home, :only => [:new, :edit, :update]
  before_filter :require_login, :only => [:create]
  before_filter :can_edit, :only => [:destroy]
  
  skip_filter :update_online_at, :get_layout_vars, :only => [:refresh_messages, :refresh_chatters]
  
  def index
    current_user.update_attribute('chatting_at', Time.now.utc) if logged_in?
    @chatters = User.chatting
    @messages = Message.paginate(:page => params[:page], :include => [:user], :order => 'messages.created_at desc')
    session[:message_id] = @messages.map(&:id).max unless @messages.empty?
  end
  
  def show
    @message = Message.find(params[:id])
  end
  
  def create
    @message = current_user.messages.build(params[:message])
    if @message.save
      render :update do |page|
        page.insert_html :top, 'messages-index', :partial => 'message', :object => @message
      end
    else
      render :nothing => true
    end
  end
  
  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    redirect_to chat_url
  end
  
  def refresh_messages
    @messages = Message.refresh(session[:message_id], current_user)
    session[:message_id] = @messages.map(&:id).max unless @messages.empty?
    if @messages
      render :update do |page|
        page.insert_html :top, 'messages-index', :partial => 'messages', :object => @messages
      end
    end
  end
  
  def refresh_chatters
    current_user.update_attribute('chatting_at', Time.now.utc) if logged_in?
    @chatters = User.chatting
    if @chatters
      render :update do |page|
        page.replace_html 'chatters', :partial => 'chatters', :object => @chatters
      end
    end
  end
end