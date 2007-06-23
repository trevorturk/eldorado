class EventsController < ApplicationController
  
  before_filter :force_login, :except => [:index, :show]
  before_filter :check_privacy, :only => [:show, :edit]
  before_filter :can_edit_event, :only => [:edit, :update, :destroy]
  before_filter :load_vars
  
  def index
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

  def load_vars
    @month = (params[:month] || Time.now.month).to_i
    @year = (params[:year] || Time.now.year).to_i
    @prev_month = @month - 1
    @prev_year = @year
    @next_month = @month + 1
    @next_year = @year
    if @prev_month == 0
      @prev_month = 12
      @prev_year = @year - 1
    end
    if @next_month == 13
      @next_month = 1
      @next_year = @year + 1
    end
  end
  
end
