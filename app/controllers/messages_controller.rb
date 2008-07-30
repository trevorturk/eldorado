class MessagesController < ApplicationController
  
  before_filter :redirect_home, :only => [:new, :edit, :update]
  before_filter :require_login, :only => [:create]
  before_filter :can_edit, :only => [:destroy]
  skip_filter :update_online_at, :get_layout_vars, :only => [:create, :more, :refresh, :refresh_chatters]
  
  def index
    @messages = Message.get(session[:online_at])
    current_user.update_attribute('chatting_at', Time.now.utc) if logged_in?
    @chatters = User.chatting
    unless @messages.empty?
      session[:message_id] = @messages.map(&:id).max
      @last_message = @messages.map(&:id).min
    end
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
  
  def more
    @messages = Message.more(params[:id])
    @last_message = @messages.map(&:id).min unless @messages.empty?
    render :update do |page|
      page.insert_html :bottom, 'messages-index', :partial => 'messages', :object => @messages
      page.replace_html 'messages-more', :partial => 'more', :object => @last_message
      page.remove 'messages-more' if @messages.size < 100
    end
  end
  
  def refresh
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
        page.redirect_to logout_path if logged_in? && current_user.logged_out?
        page.replace_html 'chatters', :partial => 'chatters', :object => @chatters
      end
    end
  end  
end