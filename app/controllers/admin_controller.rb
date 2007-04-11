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
  
  def import_punbb
    # TODO:
    # convert into a rake task?
    # deal with posts/topics/forums involving user_ids where the user is no longer in the database
    # 
    # importing: pun_bans, pun_categories, pun_forums, pun_posts, pun_ranks, pun_topics, pun_users
    # ignoring: pun_censoring, pun_config, pun_forum_perms, pun_groups, pun_online, pun_reports, pun_search_cache, pun_search_matches, pun_search_words, pun_subscriptions
    # 
    # Caveats:
    # times may not be 100% accurate due to time-zone issues, but they'll be close
    #
    # USERS
    #
    # ignoring the following fields from PunBB: 
    # group_id, title, realname, url, jabber, icq, msn, aim, yahoo, location, use_avatar, 
    # disp_topics, disp_posts, email_setting, save_pass, notify_with_post, show_smilies, 
    # show_img, show_img_sig, show_avatars, show_sig, timezone, language, style, last_post, 
    # registration_ip, admin_note, activate_string, activate_key, birthday
    #
    # not setting the following for El Dorado:
    # admin, bio, banned_until, ban_message, avatar_id, theme_id
    #
    # TODO: 
    # set some user as the admin and log current user out once conversion is done
    # set the Guest user password as something random so people won't log in as Guest
    #
    @items = ActiveRecord::Base.connection.execute('SELECT id, username, password, email, signature, num_posts, registered, last_visit FROM pun_users')
    User.destroy_all
    for i in @items
      @item = User.new
      @item.id = i[0] # id
      @item.login = i[1] # username
      @item.email = i[3] # email 
      @item.password_hash = i[2] # password 
      @item.signature = i[4] # signature       
      @item.created_at = Time.at(i[6].to_i).utc.to_time # registered 
      @item.profile_updated_at = Time.at(i[6].to_i).utc.to_time # registered 
      @item.last_login_at = Time.at(i[7].to_i).utc.to_time # last_visit 
      @item.online_at = Time.at(i[7].to_i).utc.to_time # last_visit 
      @item.posts_count = i[5] # num_posts
      @item.save!
    end
    #
    # BANS
    #
    # ignoring: id, ip, email
    #    
    @items = ActiveRecord::Base.connection.execute('SELECT username, message, expire FROM pun_bans')
    for i in @items
      @item = User.find_by_login(i[0]) # username
      @item.ban_message = i[1] # message
      @item.banned_until = Time.at(i[2].to_i).utc.to_time unless i[2].nil? # expire
      @item.banned_until = '9999-01-01 00:00:00' if i[2].nil? # if ban does not expire, set in the future
      @item.save!
    end
    #
    # RANKS
    #
    @items = ActiveRecord::Base.connection.execute('SELECT id, rank, min_posts FROM pun_ranks')
    Rank.destroy_all
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
    @items = ActiveRecord::Base.connection.execute('SELECT id, cat_name, disp_position FROM pun_categories')
    Category.destroy_all
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
    # ignoring: redirect_url, moderators, sort_by    
    #    
    @items = ActiveRecord::Base.connection.execute('SELECT id, forum_name, forum_desc, num_topics, num_posts, last_post, last_post_id, last_poster, disp_position, cat_id FROM pun_forums')
    Forum.destroy_all
    for i in @items
      @item = Forum.new
      @item.id = i[0] # id 
      @item.category_id = i[9] # cat_id
      @item.name = i[1] # forum_name
      @item.description = i[2] # forum_desc
      @item.topics_count = i[3] # num_topics
      @item.posts_count = i[4] # num_posts
      @item.position = i[8] # disp_position
      @item.last_post_id = i[6] # last_post_id
      @item.last_post_at = Time.at(i[5].to_i).utc.to_time # last_post
        @temp = User.find_by_login(i[7]) # last_poster
      @item.last_post_by = @temp.id # get user id instead of login name
      @item.save!
    end
    #
    # TOPICS
    #
    # POSTS
    #
    # DONE
  end
    
end
