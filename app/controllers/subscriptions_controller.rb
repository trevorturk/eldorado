class SubscriptionsController < ApplicationController

  before_filter :require_login

  def index
    @subscriptions = current_user.subscriptions
  end

  def toggle
    current_user.subscriptions.toggle params[:id]
    text = current_user.subscriptions.include?(params[:id]) ? 'Unsubscribe' : 'Subscribe'
    render :text => text
  end
  
  def destroy
    subscription = current_user.subscriptions.find(params[:id])
    subscription.destroy
    redirect_to subscriptions_path
  end
  
end
