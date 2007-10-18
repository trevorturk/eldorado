class EventsController < ApplicationController
  
  before_filter :require_login, :except => [:index, :show]
  before_filter :check_privacy, :only => [:show, :edit]
  before_filter :can_edit, :only => [:edit, :update, :destroy]
  
  def index
    @date = Time.parse("#{params[:date]} || TzTime.now")
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
  end

  def edit
    @event = Event.find(params[:id])
  end

  def create
    @event = current_user.events.build params[:event]
    if @event.save
      redirect_to events_url
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
