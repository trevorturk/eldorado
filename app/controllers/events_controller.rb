class EventsController < ApplicationController
  
  before_filter :require_login, :except => [:index, :show]
  before_filter :can_edit, :only => [:edit, :update, :destroy]
  
  def index
    @date = Time.parse("#{params[:date]} || Time.now.utc")
    @events = Event.find(:all, :conditions => ['date between ? and ?', @date.strftime("%Y-%m") + '-01', @date.next_month.strftime("%Y-%m") + '-01'])
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
  end

  def create
    @event = current_user.events.build(params[:event])
    if @event.save
      redirect_to @event and return true
    else
      render :action => "new"
    end
  end

  def edit
    @event = Event.find(params[:id])
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
    redirect_to events_path
  end
end
