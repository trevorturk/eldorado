namespace :db do
  desc "Imports PunBB content"
  task :import => :environment do
    system "rake db:schema:load"
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[RAILS_ENV])
    if (User.count != 0) or (Option.count != 0)
      puts 'Error: Setup can only be performed on an empty database.'
      exit
    end
    #
    # ABOUT
    #
    # This will import a PunBB database into the El Dorado structure. 
    # Before doing anything else this will completely destroy your existing El Dorado database. 
    # It will most likely take a long time, so importing to/from a remote database might be a bad idea.
    # Be careful to keep your text encoding consistent. Most databases will be in latin1.
    # This whole shebang is only tested with PunBB 1.2.15. Times may not be 100% accurate
    # due to time-zone and daylight savings issues, but they'll be close.
    # The user with id 2 (the "guest" user is 1) will be set as the only "admin" user.
    # Any topics, posts, etc made by a user not in the database will be assigned to the "guest" user.
    # 
    # importing: pun_bans, pun_categories, pun_config, pun_forums, pun_posts, pun_ranks, pun_topics, pun_users, pun_subscriptions
    # ignoring: pun_censoring, pun_forum_perms, pun_groups, pun_online, pun_reports, pun_search_cache, pun_search_matches, pun_search_words
    # 
    # STORE RAILS DATABASE CONNECTION INFO
    #
    eldorado = ActiveRecord::Base.configurations
    prefix = eldorado['import']['prefix']
    puts 'Starting import...'
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
    # CONFIG
    #
    # ignoring: almost everything
    # importing: o_cur_version, o_board_title, o_board_desc, o_server_timezone
    #
    puts 'Importing configuration...'
    ActiveRecord::Base.establish_connection(eldorado['import'])
    @items = ActiveRecord::Base.connection.execute("SELECT conf_name, conf_value FROM #{prefix}config LIMIT 4")
    ActiveRecord::Base.establish_connection(eldorado[RAILS_ENV])
    @item = Option.new
    @index = 0
    for i in @items 
      @index += 1
      @item.site_title = i[1] if @index == 2 # o_board_title
      @item.site_tagline = i[1] if @index == 3 # o_board_desc
      TZ = i[1].to_i if @index == 4 # o_server_timezone
    end
    @item.footer_left = ''
    @item.footer_right = 'Powered by El Dorado | <a href="http://almosteffortless.com">&aelig;</a>'
    @item.newest_user = 'Newest User'
    @item.admin_rank = 'Administrator'
    @item.save!
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
    puts 'Importing users...'
    ActiveRecord::Base.establish_connection(eldorado['import'])
    @items = ActiveRecord::Base.connection.execute("SELECT id, username, password, email, signature, registered, last_visit FROM #{prefix}users")
    ActiveRecord::Base.establish_connection(eldorado[RAILS_ENV])
    for i in @items
      @item = User.new
      @item.id = i[0] # id
      @item.login = i[1] # username
      @item.password_hash = i[2] # password 
      @item.email = i[3] # email 
      @item.signature = i[4] # signature       
      @item.created_at = Time.at(i[5].to_i).utc.to_time+(TZ.hours) # registered 
      @item.online_at = Time.at(i[6].to_i).utc.to_time+(TZ.hours) # last_visit 
        @item.password_hash = User.encrypt(rand.to_s) if @item.login == 'Guest' # random password for Guest user
        @item.admin = true if @item.id == 2 # make first non-guest user into admin
      @item.save!
      # manually fix timestamp issues raised by controller actions etc
      ActiveRecord::Base.connection.execute("UPDATE users SET profile_updated_at = '#{Time.at(i[5].to_i).utc+(TZ.hours).to_s(:db)}', last_login_at = '#{Time.at(i[6].to_i).utc+(TZ.hours).to_s(:db)}' WHERE id = '#{@item.id}'")
      puts "Importing user: #{@item.id}"
    end
    #
    # BANS
    #
    puts 'Importing bans...'
    ActiveRecord::Base.establish_connection(eldorado['import'])
    @items = ActiveRecord::Base.connection.execute("SELECT id, username, ip, email, message, expire FROM #{prefix}bans")
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
      @item.expires_at = Time.at(i[5].to_i).utc.to_time+(TZ.hours) unless i[5].nil? # expire
      @item.save!
      puts "Importing ban: #{@item.id}"
    end
    #
    # RANKS
    #
    puts 'Importing ranks...'
    ActiveRecord::Base.establish_connection(eldorado['import'])
    @items = ActiveRecord::Base.connection.execute("SELECT id, rank, min_posts FROM #{prefix}ranks")
    ActiveRecord::Base.establish_connection(eldorado[RAILS_ENV])
    for i in @items
      @item = Rank.new
      @item.id = i[0] # id 
      @item.title = i[1] # rank
      @item.min_posts = i[2] # min_posts
      @item.save!
      puts "Importing rank: #{@item.id}"
    end
    #
    # CATEGORIES
    #
    puts 'Importing categories...'
    ActiveRecord::Base.establish_connection(eldorado['import'])
    @items = ActiveRecord::Base.connection.execute("SELECT id, cat_name, disp_position FROM #{prefix}categories")
    ActiveRecord::Base.establish_connection(eldorado[RAILS_ENV])
    for i in @items
      @item = Category.new
      @item.id = i[0] # id 
      @item.name = i[1] # cat_name
      @item.position = i[2] # disp_position
      @item.save!
      puts "Importing category: #{@item.id}"
    end
    #
    # FORUMS
    #
    # ignoring: redirect_url, moderators, sort_by, 
    # num_topics (will be updated during import), num_posts (will be updated during import)
    # 
    puts 'Importing forums...'
    ActiveRecord::Base.establish_connection(eldorado['import'])
    @items = ActiveRecord::Base.connection.execute("SELECT id, forum_name, forum_desc, last_post, last_post_id, last_poster, disp_position, cat_id FROM #{prefix}forums")
    ActiveRecord::Base.establish_connection(eldorado[RAILS_ENV])
    for i in @items
      @item = Forum.new
      @item.id = i[0] # id 
      @item.name = i[1] # forum_name
      @item.description = i[2] # forum_desc
      @item.last_post_at = Time.at(i[3].to_i).utc.to_time+(TZ.hours) # last_post
      @item.last_post_id = i[4] # last_post_id
        @temp = User.find_by_login(i[5]) # last_poster
        @temp = User.find_by_id(1) if @temp.nil? # assign to guest account if user isn't found
      @item.last_post_by = @temp.id # get user id instead of username
      @item.position = i[6] # disp_position
      @item.category_id = i[7] # cat_id
      @item.save!
      puts "Importing forum: #{@item.id}"
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
    puts 'Importing topics...'
    ActiveRecord::Base.establish_connection(eldorado['import'])
    @items = ActiveRecord::Base.connection.execute("SELECT id, poster, subject, posted, last_post, last_post_id, last_poster, num_views, closed, sticky, forum_id FROM #{prefix}topics")
    ActiveRecord::Base.establish_connection(eldorado[RAILS_ENV])
    for i in @items
      @item = Topic.new
      @item.id = i[0] # id 
        @temp = User.find_by_login(i[1]) # poster
        @temp = User.find_by_id(1) if @temp.nil? # assign to guest account if user isn't found
      @item.user_id = @temp.id # get user id instead of username 
      @item.title = i[2] # subject 
      @item.created_at = Time.at(i[3].to_i).utc.to_time+(TZ.hours) # posted
      @item.last_post_at = Time.at(i[4].to_i).utc.to_time+(TZ.hours) # last_post
      @item.last_post_id = i[5] # last_post_id      
        @temp = User.find_by_login(i[6]) # last_poster
        @temp = User.find_by_id(1) if @temp.nil? # assign to guest account if user isn't found
      @item.last_post_by = @temp.id # get user id instead of username
      @item.views = i[7] # num_views
      @item.closed = i[8] # closed
      @item.sticky = i[9] # sticky
      @item.forum_id = i[10] # forum_id
      @item.save!
      puts "Importing topic: #{@item.id}"
    end
    #
    # POSTS
    #
    # ignoring: poster, poster_ip, poster_email, hide_smilies
    #
    puts 'Importing posts...'
    ActiveRecord::Base.establish_connection(eldorado['import'])
    @items = ActiveRecord::Base.connection.execute("SELECT id, poster_id, message, posted, edited, edited_by, topic_id FROM #{prefix}posts")
    ActiveRecord::Base.establish_connection(eldorado[RAILS_ENV])
    for i in @items
      @item = Post.new
      @item.id = i[0] # id 
      @item.user_id = i[1] # poster_id 
      @item.body = i[2] # message
      @item.created_at = Time.at(i[3].to_i).utc.to_time+(TZ.hours) # posted
      unless i[5].nil? # edited_by
          @temp = User.find_by_login(i[5]) # edited_by
          @temp = User.find_by_id(1) if @temp.nil? # assign to guest account if user isn't found
        @item.updated_by = @temp.id # get user id instead of username
      end
      @item.topic_id = i[6] # topic_id      
      @item.save!
      # manually fix timestamp issues raised by controller actions etc
      if i[4].nil? # edited
        ActiveRecord::Base.connection.execute("UPDATE posts SET updated_at = '#{Time.at(i[3].to_i).utc+(TZ.hours).to_s(:db)}' WHERE id = '#{@item.id}'") # posted
      else
        ActiveRecord::Base.connection.execute("UPDATE posts SET updated_at = '#{Time.at(i[4].to_i).utc+(TZ.hours).to_s(:db)}' WHERE id = '#{@item.id}'") # edited
      end
      puts "Importing post: #{@item.id}"
    end
    #
    # SUBSCRIPTIONS
    #
    puts 'Importing subscriptions...'
    ActiveRecord::Base.establish_connection(eldorado['import'])
    @items = ActiveRecord::Base.connection.execute("SELECT user_id, topic_id FROM #{prefix}subscriptions")
    ActiveRecord::Base.establish_connection(eldorado[RAILS_ENV])
    for i in @items
      @item = Subscription.new
      @item.user_id = i[0] # user_id 
      @item.topic_id = i[1] # topic_id 
      @item.save!
    end
    #
    # DONE
    #
    puts 'Import completed successfully.'
  end
end