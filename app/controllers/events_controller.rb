class EventsController < ApplicationController
  
  before_filter :load_vars
  
  # GET /events
  # GET /events.xml
  def index
    @events = Event.find(:all, :order => 'date desc')

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @events.to_xml }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @event.to_xml }
    end
  end

  # GET /events/new
  def new
  end

  # GET /events/1;edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to events_url }
        format.xml  { head :created, :location => event_url(@event) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors.to_xml }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to events_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors.to_xml }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.xml  { head :ok }
    end
  end
  
private

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
