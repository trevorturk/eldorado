class MessagesController < ApplicationController
  
  before_filter :redirect_home, :only => [:show, :new, :edit, :update]
  before_filter :require_login, :only => [:new, :create]
  before_filter :can_edit, :only => [:destroy]
  before_filter :update_chatters, :only => [:index, :refresh]
  
  skip_filter :update_online_at, :get_layout_vars, :only => [:refresh]
  
  def index
    @messages = Message.recent(params[:limit] || 30)
    session[:message_id] = @messages.map(&:id).max unless @messages.empty?
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
    if @message.destroy
      render :update do |page|
        page.remove "message-#{@message.id}"
      end
    else
      render :nothing => true
    end
  end
  
  def refresh
    @messages = Message.refresh(session[:message_id], current_user)
    session[:message_id] = @messages.map(&:id).max unless @messages.empty?
    if @messages
      render :update do |page|
        page.insert_html :top, 'messages-index', :partial => 'messages', :object => @messages
        page.replace_html 'chatters', :partial => 'chatters', :object => @chatters
      end
    end
  end
  
  def update_chatters
    current_user.update_attribute('chatting_at', Time.now) if logged_in?
    @chatters = User.chatting
  end
end