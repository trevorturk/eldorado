class SubscriptionsController < ApplicationController

  before_filter :check_logged_in

  def index
    @subscriptions = current_user.subscriptions
  end

  def toggle
    current_user.subscriptions.toggle params[:id]
    render :nothing => true
  end
  
  def destroy
    current_user.subscriptions.destroy params[:id]
    redirect_to subscriptions_path
  end
  
  private
    def check_logged_in
      redirect_to root_path unless logged_in?
    end

end
