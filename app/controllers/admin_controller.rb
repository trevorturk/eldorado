class AdminController < ApplicationController
  
  before_filter :check_admin 
  
  def index
  end
  
  def themes
    @themes = Theme.find(:all)
    render :template => 'themes/index'
  end
  
  def import
    if !request.post?
      render :template => 'admin/import'
    else
      import_punbb
      flash[:notice] = 'fin'
    end
  end
  
  protected
  
  def import_punbb
    #
    # TODO:
    # convert into a rake task?
    # 
    # importing: pun_bans, pun_categories, pun_forums, pun_posts, pun_ranks, pun_topics, pun_users, pun_subscriptions
    # ignoring: pun_censoring, pun_config, pun_forum_perms, pun_groups, pun_online, pun_reports, pun_search_cache, pun_search_matches, pun_search_words
    # 
    # Caveats:
    # times may not be 100% accurate due to time-zone issues, but they'll be close
    #
    # ---
    # 
    # STORE RAILS DATABASE CONNECTION INFO
    #
    eldorado = ActiveRecord::Base.configurations
    #
    # DESTROY EXISTING ELDORADO DATABASE
    #
    Avatar.destroy_all
    Event.destroy_all
    Header.destroy_all
    Option.destroy_all
    Theme.destroy_all
    Upload.destroy_all
    #
    User.destroy_all
    Ban.destroy_all
    Rank.destroy_all
    Category.destroy_all
    Forum.destroy_all
    Topic.destroy_all
    Post.destroy_all
    Subscription.destroy_all
    #
    # USERS
    #
    # ignoring the following fields from PunBB: 
    # num_posts (will be updated during import), 
    # group_id, title, realname, url, jabber, icq, msn, aim, yahoo, location, use_avatar, 
    # disp_topics, disp_posts, email_setting, save_pass, notify_with_post, show_smilies, 
    # show_img, show_img_sig, show_avatars, show_sig, timezone, language, style, last_post, 
    # registration_ip, admin_note, activate_string, activate_key, birthday
    #
    # not setting the following for El Dorado:
    # admin, bio, avatar_id
    #
    ActiveRecord::Base.establish_connection(params[:punbb])
    @items = ActiveRecord::Base.connection.execute("SELECT id, username, password, email, signature, registered, last_visit FROM #{params[:prefix]}users")
    ActiveRecord::Base.establish_connection(eldorado[RAILS_ENV])
    for i in @items
      @item = User.new
      @item.id = i[0] # id
      @item.login = i[1] # username
      @item.password_hash = i[2] # password 
      @item.email = i[3] # email 
      @item.signature = i[4] # signature       
      @item.created_at = Time.at(i[5].to_i).utc.to_time # registered 
      @item.online_at = Time.at(i[6].to_i).utc.to_time # last_visit 
        @item.password_hash = User.encrypt(rand.to_s) if @item.login == 'Guest' # random password for Guest user
        @item.admin = true if @item.id == 2 # make first non-guest user into admin
      @item.save!
      # manually fix timestamp issues raised by controller actions etc
      ActiveRecord::Base.connection.execute("UPDATE users SET profile_updated_at = '#{Time.at(i[5].to_i).utc.to_s(:db)}', last_login_at = '#{Time.at(i[6].to_i).utc.to_s(:db)}' WHERE id = '#{@item.id}'")
    end
    #
    # BANS
    #
    ActiveRecord::Base.establish_connection(params[:punbb])
    @items = ActiveRecord::Base.connection.execute("SELECT id, username, ip, email, message, expire FROM #{params[:prefix]}bans")
    ActiveRecord::Base.establish_connection(eldorado[RAILS_ENV])
    for i in @items
      @item = Ban.new
      @item.id = i[0] # id
        @temp = User.find_by_login(i[1]) # username
        @temp = User.find_by_id(1) if @temp.nil? # assign to guest account if user isn't found
      @item.user_id = @temp.id # get user_id instead of username      
      @item.ip = i[2] # ip
      @item.email = i[3] # email
      @item.message = i[4] # message
      @item.expires_at = Time.at(i[5].to_i).utc.to_time unless i[5].nil? # expire
      @item.save!
    end
    #
    # RANKS
    #
    ActiveRecord::Base.establish_connection(params[:punbb])
    @items = ActiveRecord::Base.connection.execute("SELECT id, rank, min_posts FROM #{params[:prefix]}ranks")
    ActiveRecord::Base.establish_connection(eldorado[RAILS_ENV])
    for i in @items
      @item = Rank.new
      @item.id = i[0] # id 
      @item.title = i[1] # rank
      @item.min_posts = i[2] # min_posts
      @item.save!
    end
    #
    # CATEGORIES
    #
    ActiveRecord::Base.establish_connection(params[:punbb])
    @items = ActiveRecord::Base.connection.execute("SELECT id, cat_name, disp_position FROM #{params[:prefix]}categories")
    ActiveRecord::Base.establish_connection(eldorado[RAILS_ENV])
    for i in @items
      @item = Category.new
      @item.id = i[0] # id 
      @item.name = i[1] # cat_name
      @item.position = i[2] # disp_position
      @item.save!
    end
    #
    # FORUMS
    #
    # ignoring: redirect_url, moderators, sort_by, 
    # num_topics (will be updated during import), num_posts (will be updated during import)
    # 
    ActiveRecord::Base.establish_connection(params[:punbb])
    @items = ActiveRecord::Base.connection.execute("SELECT id, forum_name, forum_desc, last_post, last_post_id, last_poster, disp_position, cat_id FROM #{params[:prefix]}forums")
    ActiveRecord::Base.establish_connection(eldorado[RAILS_ENV])
    for i in @items
      @item = Forum.new
      @item.id = i[0] # id 
      @item.name = i[1] # forum_name
      @item.description = i[2] # forum_desc
      @item.last_post_at = Time.at(i[3].to_i).utc.to_time # last_post
      @item.last_post_id = i[4] # last_post_id
        @temp = User.find_by_login(i[5]) # last_poster
        @temp = User.find_by_id(1) if @temp.nil? # assign to guest account if user isn't found
      @item.last_post_by = @temp.id # get user id instead of username
      @item.position = i[6] # disp_position
      @item.category_id = i[7] # cat_id
      @item.save!
    end
    #
    # TOPICS
    #
    # Caveats:
    # assigning posts with no corresponding user to the "guest" user since we're storing user_id instead of username
    # ignoring moved_to, so any topics that have been moved with the Leave redirect topic(s) checkbox will have to be moved manually
    # 
    # ignoring: moved_to, num_replies (will be updated during import)
    # 
    ActiveRecord::Base.establish_connection(params[:punbb])
    @items = ActiveRecord::Base.connection.execute("SELECT id, poster, subject, posted, last_post, last_post_id, last_poster, num_views, closed, sticky, forum_id FROM #{params[:prefix]}topics")
    ActiveRecord::Base.establish_connection(eldorado[RAILS_ENV])
    for i in @items
      @item = Topic.new
      @item.id = i[0] # id 
        @temp = User.find_by_login(i[1]) # poster
        @temp = User.find_by_id(1) if @temp.nil? # assign to guest account if user isn't found
      @item.user_id = @temp.id # get user id instead of username 
      @item.title = i[2] # subject 
      @item.created_at = Time.at(i[3].to_i).utc.to_time # posted
      @item.last_post_at = Time.at(i[4].to_i).utc.to_time # last_post
      @item.last_post_id = i[5] # last_post_id      
        @temp = User.find_by_login(i[6]) # last_poster
        @temp = User.find_by_id(1) if @temp.nil? # assign to guest account if user isn't found
      @item.last_post_by = @temp.id # get user id instead of username
      @item.views = i[7] # num_views
      @item.closed = i[8] # closed
      @item.sticky = i[9] # sticky
      @item.forum_id = i[10] # forum_id
      @item.save!
    end
    #
    # POSTS
    #
    # ignoring: poster, poster_ip, poster_email, hide_smilies
    #
    ActiveRecord::Base.establish_connection(params[:punbb])
    @items = ActiveRecord::Base.connection.execute("SELECT id, poster_id, message, posted, edited, edited_by, topic_id FROM #{params[:prefix]}posts")
    ActiveRecord::Base.establish_connection(eldorado[RAILS_ENV])
    for i in @items
      @item = Post.new
      @item.id = i[0] # id 
      @item.user_id = i[1] # poster_id 
      @item.body = i[2] # message
      @item.created_at = Time.at(i[3].to_i).utc.to_time # posted
      unless i[5].nil? # edited_by
          @temp = User.find_by_login(i[5]) # edited_by
          @temp = User.find_by_id(1) if @temp.nil? # assign to guest account if user isn't found
        @item.updated_by = @temp.id # get user id instead of username
      end
      @item.topic_id = i[6] # topic_id      
      @item.save!
      # manually fix timestamp issues raised by controller actions etc
      if i[4].nil? # edited
        ActiveRecord::Base.connection.execute("UPDATE posts SET updated_at = '#{Time.at(i[3].to_i).utc.to_s(:db)}' WHERE id = '#{@item.id}'") # posted
      else
        ActiveRecord::Base.connection.execute("UPDATE posts SET updated_at = '#{Time.at(i[4].to_i).utc.to_s(:db)}' WHERE id = '#{@item.id}'") # edited
      end
    end
    #
    # SUBSCRIPTIONS
    #
    ActiveRecord::Base.establish_connection(params[:punbb])
    @items = ActiveRecord::Base.connection.execute("SELECT user_id, topic_id FROM #{params[:prefix]}subscriptions")
    ActiveRecord::Base.establish_connection(eldorado[RAILS_ENV])
    for i in @items
      @item = Subscription.new
      @item.user_id = i[0] # user_id 
      @item.topic_id = i[1] # topic_id 
      @item.save!
    #
    # DONE
    #
  end
    
end
