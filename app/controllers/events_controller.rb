class EventsController < ApplicationController
  
  before_filter :force_login, :except => [:index, :show]
  before_filter :check_privacy, :only => [:show, :edit]
  before_filter :can_edit_event, :only => [:edit, :update, :destroy]
  
  def index
    @date = Time.parse("#{params[:date]} || Time.now")
    if logged_in?
      @events = Event.paginate(:page => params[:page], :order => 'updated_at desc')
    else
      @events = Event.paginate(:page => params[:page], :order => 'updated_at desc', :conditions => ["private = ?", false])
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
    render :template => "events/_new"
  end

  def edit
    @event = Event.find(params[:id])
  end

  def create
    @event = current_user.events.build params[:event]
    if @event.save
      @event.date = TzTime.zone.utc_to_local(@event.date)
      @event.save
      redirect_to events_url
    else
      render :action => "_new"
    end
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      redirect_to event_url(@event)
    else
      render :action => "edit"
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_url
  end
    
  def check_privacy
    @event = Event.find(params[:id])
    redirect_to login_path if (!logged_in? && @event.private)
  end
    
  def can_edit_event
    @event = Event.find(params[:id])
    redirect_to event_path(@event) and return false unless admin? || (current_user == @event.user)
  end
  
end
