class TopicsController < ApplicationController
  
  before_filter :force_login, :except => [ :index, :show ]
  
  # GET /topics
  # GET /topics.xml
  def index
    @topics = Topic.find(:all, :order => 'last_post_at desc')

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @topics.to_xml }
    end
  end

  # GET /topics/1
  # GET /topics/1.xml
  def show
    @topic = Topic.find(params[:id])
    @posts = @topic.posts.find(:all)
    @topic.view!
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @topic.to_xml }
    end
  end

  # GET /topics/new
  def new
    @topic = Topic.new
  end

  # GET /topics/1;edit
  def edit
    @topic = Topic.find(params[:id])
  end

  # POST /topics
  # POST /topics.xml
  def create
    @topic = Topic.new(params[:topic])
    if @topic
      @topic.user_id = current_user.id
      @topic.user_name = current_user.login
      @topic.last_post_user_id = current_user.id
      @topic.last_post_user_name = current_user.login
      @topic.last_post_at = Time.now
      @topic.posts_count = -1
      @post = @topic.posts.build(params[:topic])
      @post.user_id = current_user.id
    end

    respond_to do |format|
      if @topic.save && @post.save
        flash[:notice] = 'Topic was successfully created.'
        format.html { redirect_to topic_url(@topic) }
        format.xml  { head :created, :location => topic_url(@topic) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @topic.errors.to_xml }
      end
    end
  end

  # PUT /topics/1
  # PUT /topics/1.xml
  def update
    @topic = Topic.find(params[:id])

    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        flash[:notice] = 'Topic was successfully updated.'
        format.html { redirect_to topic_url(@topic) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @topic.errors.to_xml }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.xml
  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to topics_url }
      format.xml  { head :ok }
    end
  end
  
  def unknown_request
    redirect_to_home('Sorry, the page you requested could not be found.')
  end
  
end
