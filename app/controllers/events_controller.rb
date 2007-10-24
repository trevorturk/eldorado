class EventsController < ApplicationController
  
  before_filter :require_login, :except => [:index, :show]
  before_filter :check_privacy, :only => [:show, :edit]
  before_filter :can_edit, :only => [:edit, :update, :destroy]
  
  def index
    @date = Time.parse("#{params[:date]} || TzTime.now")
    if logged_in?
      @events = Event.find(:all, :conditions => ['created_at between ? and ?', @date.strftime("%Y-%m") + '-01', @date.next_month.strftime("%Y-%m") + '-01'])
    else
      @events = Event.find(:all, :conditions => ['created_at between ? and ? and private = ?', @date.strftime("%Y-%m") + '-01', @date.next_month.strftime("%Y-%m") + '-01', false])
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
  end

  def edit
    @event = Event.find(params[:id])
  end

  def create
    @event = current_user.events.build params[:event]
    if @event.save
      redirect_to @event
    else
      render :action => "new"
    end
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      redirect_to @event
    else
      render :action => "edit"
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_url
  end
  
end
