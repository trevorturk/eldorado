def tz_to_timezone(tz)
  timezone = (tz == 0) ? "" : (-tz > 0) ? "+#{-tz}" : "#{-tz}"
  "Etc/GMT#{timezone}"
end

namespace :import do
  desc "Imports a PunBB (version 1.2.15) database"
  task :database => :environment do
    # For config/database.yml:
    # import:
    #   adapter: mysql
    #   database: punbb
    #   username: root
    #   password: 
    #   host: localhost
    #   prefix: pun_
    puts "NOTE: This rake task has not been updated in quite some time and is unlikely to work. Contributions welcome!"
    puts "This task will import from a PunBB database defined as 'import' in your database.yml file."
    puts "It will import into your 'development' database unless you specify otherwise (e.g. 'rake db:import RAILS_ENV=production')."
    puts "Please make sure the receiving database is empty before continuing."
    puts "Tested with PunBB version 1.2.15."
    puts "WARNING: The importing of timestamps and timezones isn't 100% accurate. Proceed at your own risk."
    puts "Type '1' to continue, or '2' to quit."
    confirmation = STDIN.gets.chomp
    exit unless confirmation == "1"
    system "rake db:schema:load"
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[RAILS_ENV])
    #
    # ABOUT
    #
    # This will import a PunBB database into the El Dorado structure. Only tested with PunBB 1.2.15.
    # The user with id 2 (the "guest" user is 1) will be set as the only "admin" user.
    # Any topics, posts, etc made by a user not in the database will be assigned to the "guest" user.
    # WARNING: The importing of timestamps and timezones isn't 100% accurate. Proceed at your own risk. 
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
    # CONFIG
    #
    # ignoring: almost everything
    # importing: o_cur_version, o_board_title, o_board_desc, o_server_timezone
    #
    puts 'Importing configuration...'
    ActiveRecord::Base.establish_connection(eldorado['import'])
    @items = ActiveRecord::Base.connection.execute("SELECT conf_name, conf_value FROM #{prefix}config LIMIT 4")
    ActiveRecord::Base.establish_connection(eldorado[RAILS_ENV])
    @item = Setting.new
    @index = 0
    for i in @items 
      @index += 1
      @item.title = i[1] if @index == 2 # o_board_title
      @item.tagline = i[1] if @index == 3 # o_board_desc
      tz = i[1].to_i if @index == 4 # o_server_timezone
    end
    Time.zone = Time.zone.get(tz_to_timezone(tz))
    @item.announcement = ''
    @item.footer = '<p style="text-align:right;margin:0;">Powered by El Dorado | <a href="http://almosteffortless.com">&aelig;</a></p>'
    @item.save!
    #
    # USERS
    #
    # ignoring the following fields from PunBB: 
    # num_posts (will be updated during import), 
    # group_id, title, realname, url, jabber, icq, msn, aim, yahoo, location, use_avatar, 
    # disp_topics, disp_posts, email_setting, save_pass, notify_with_post, show_smilies, 
    # show_img, show_img_sig, show_avatars, show_sig, language, style, last_post, 
    # registration_ip, admin_note, activate_string, activate_key, birthday
    #
    # not setting the following for El Dorado:
    # admin, bio, avatar_id
    #
    puts 'Importing users...'
    ActiveRecord::Base.establish_connection(eldorado['import'])
    @items = ActiveRecord::Base.connection.execute("SELECT id, username, password, email, signature, registered, last_visit, timezone FROM #{prefix}users")
    ActiveRecord::Base.establish_connection(eldorado[RAILS_ENV])
    for i in @items
      @item = User.new
      @item.id = i[0] # id
      @item.login = i[1] # username
      @item.password_hash = i[2] # password 
      @item.email = i[3] # email 
      @item.signature = i[4] # signature
      @item.created_at = Time.at(Time.at(i[5].to_i)) # registered 
        @item.password_hash = User.encrypt(rand.to_s) if @item.login == 'Guest' # random password for Guest user
        @item.admin = true if @item.id == 2 # make first non-guest user into admin
      @item.save!
      # manually fix timestamp issues raised by controller actions
        @item.profile_updated_at = @item.created_at 
        @item.online_at = Time.at(Time.at(i[6].to_i)) # last_visit 
        tz = i[7].to_i
        @item.time_zone = tz_to_timezone(tz)
        @item.save!
      puts "Importing user: #{@item.id}"
    end
    #
    # BANS
    #
    puts 'Importing bans...'
    ActiveRecord::Base.establish_connection(eldorado['import'])
    @items = ActiveRecord::Base.connection.execute("SELECT username, message, expire FROM #{prefix}bans")
    ActiveRecord::Base.establish_connection(eldorado[RAILS_ENV])
    for i in @items
      @item = User.find_by_login(i[0]) # username
      @item.ban_message = i[1] # message
      @item.banned_until = Time.at(Time.at(i[2].to_i)) unless i[2].nil? # expire
      @item.save!
      puts "Importing ban: #{@item.login}"
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
    # ignoring: redirect_url, moderators, sort_by, num_topics/num_posts will be updated during import
    # 
    puts 'Importing forums...'
    ActiveRecord::Base.establish_connection(eldorado['import'])
    @items = ActiveRecord::Base.connection.execute("SELECT id, forum_name, forum_desc, disp_position, cat_id FROM #{prefix}forums")
    ActiveRecord::Base.establish_connection(eldorado[RAILS_ENV])
    for i in @items
      @item = Forum.new
      @item.id = i[0] # id 
      @item.name = i[1] # forum_name
      @item.description = i[2] # forum_desc
      @item.position = i[3] # disp_position
      @item.category_id = i[4] # cat_id
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
    @items = ActiveRecord::Base.connection.execute("SELECT id, poster, subject, posted, last_post, last_post_id, last_poster, num_views, closed, sticky, forum_id FROM #{prefix}topics WHERE last_post_id != 0")
    ActiveRecord::Base.establish_connection(eldorado[RAILS_ENV])
    for i in @items
      @item = Topic.new
      @item.id = i[0] # id 
        @temp = User.find_by_login(i[1]) # poster
        @temp = User.find_by_id(1) if @temp.nil? # assign to guest account if user isn't found
      @item.user_id = @temp.id # get user id instead of username 
      @item.title = i[2] # subject 
      @item.created_at = Time.at(Time.at(i[3].to_i)) # posted
      @item.last_post_at = Time.at(Time.at(i[4].to_i)) # last_post
      @item.last_post_id = i[5] # last_post_id      
        @temp = User.find_by_login(i[6]) # last_poster
        @temp = User.find_by_id(1) if @temp.nil? # assign to guest account if user isn't found
      @item.last_post_by = @temp.id # get user id instead of username
      @item.views = i[7] # num_views
      @item.locked = i[8] # locked
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
    # disable timestamping to fix timestamp issues raised by controller actions etc
    ActiveRecord::Base.record_timestamps = false
    for i in @items
      @item = Post.new
      @item.id = i[0] # id 
      @item.user_id = i[1] # poster_id 
      @item.body = i[2] # message
      @item.created_at = Time.at(Time.at(i[3].to_i)) # posted
      if i[4].nil? # edited
        @item.updated_at = Time.at(Time.at(i[3].to_i)) # posted
      else
        @item.updated_at = Time.at(Time.at(i[4].to_i)) # edited
      end
      unless i[5].nil? # edited_by
          @temp = User.find_by_login(i[5]) # edited_by
          @temp = User.find_by_id(1) if @temp.nil? # assign to guest account if user isn't found
        @item.updated_by = @temp.id # get user id instead of username
      end
      @item.topic_id = i[6] # topic_id
      @item.save!
      puts "Importing post: #{@item.id}"
    end
    # re-enable timestamping
    ActiveRecord::Base.record_timestamps = true
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

namespace :import do
  desc "Imports PunBB avatars in public/avatars and associates them with their corresponding users"
  task :avatars => :environment do
    ActiveRecord::Base.record_timestamps = false
    @items = Dir.glob(RAILS_ROOT+'/public/avatars/*')
    @items.each do |item|
      @item = Avatar.new
      @item.filename = File.basename(item)
      @item.size = File.size(item)
      @item.content_type = 'application/octet-stream'
      @item.content_type = 'image/jpeg' if File.extname(item).downcase == '.jpg'
      @item.content_type = 'image/jpeg' if File.extname(item).downcase == '.jpeg'
      @item.content_type = 'image/gif' if File.extname(item).downcase == '.gif'
      @item.content_type = 'image/png' if File.extname(item).downcase == '.png'
      begin # find corresponding user or use the guest
        @user_id = File.basename(item).chomp(".")
        @item.user_id = User.find(@user_id).id
      rescue
        @item.user_id = 1
      end
      @item.current_user_id = @item.user_id
      @item.created_at = File.mtime(item)
      @item.updated_at = File.mtime(item)
      @item.save!
      User.update_all ['avatar = ?', @item.attachment.url], ['id = ?', @item.user_id]
      puts "Importing avatar: #{@item.id}"
    end
    # remove guest user's avatar
    User.update_all ['avatar = ?', nil], ['id = ?', 1] 
    Avatar.update_all ['current_user_id = ?', nil], ['current_user_id = ?', 1] 
    puts 'Import completed successfully.'
  end
end

namespace :import do
  desc "Imports headers in public/headers and associates them with guest user (id=1)"
  task :headers => :environment do
    ActiveRecord::Base.record_timestamps = false
    @items = Dir.glob(RAILS_ROOT+'/public/headers/*')
    @items.each do |item|
      @item = Header.new
      @item.filename = File.basename(item)
      @item.size = File.size(item)
      @item.content_type = 'application/octet-stream'
      @item.content_type = 'image/jpeg' if File.extname(item).downcase == '.jpg'
      @item.content_type = 'image/jpeg' if File.extname(item).downcase == '.jpeg'
      @item.content_type = 'image/gif' if File.extname(item).downcase == '.gif'
      @item.content_type = 'image/png' if File.extname(item).downcase == '.png'
      @item.user_id = 1
      @item.created_at = File.mtime(item)
      @item.updated_at = File.mtime(item)
      @item.save!
      puts "Importing header: #{@item.id}"
    end
    puts 'Import completed successfully.'
  end
end

namespace :import do
  desc "Imports files in public/files and associates them with guest user (id=1)"
  task :files => :environment do
    ActiveRecord::Base.record_timestamps = false
    @items = Dir.glob(RAILS_ROOT+'/public/files/*')
    @items.each do |item|
      @item = Upload.new
      @item.filename = File.basename(item)
      @item.size = File.size(item)
      @item.content_type = 'application/octet-stream'
      @item.content_type = 'video/3gpp2' if File.extname(item).downcase == '.3g2'
      @item.content_type = 'audio/x-aiff' if File.extname(item).downcase == '.aif'
      @item.content_type = 'video/x-ms-asf' if File.extname(item).downcase == '.asf'
      @item.content_type = 'video/x-msvideo' if File.extname(item).downcase == '.avi'
      @item.content_type = 'image/bmp' if File.extname(item).downcase == '.bmp'
      @item.content_type = 'text/css' if File.extname(item).downcase == '.css'
      @item.content_type = 'application/msword' if File.extname(item).downcase == '.doc'
      @item.content_type = 'image/gif' if File.extname(item).downcase == '.gif'
      @item.content_type = 'text/html' if File.extname(item).downcase == '.html'
      @item.content_type = 'image/jpeg' if File.extname(item).downcase == '.jpe'
      @item.content_type = 'image/jpeg' if File.extname(item).downcase == '.jpeg'
      @item.content_type = 'image/jpeg' if File.extname(item).downcase == '.jpg'
      @item.content_type = 'application/x-javascript' if File.extname(item).downcase == '.js'
      @item.content_type = 'audio/midi' if File.extname(item).downcase == '.mid'
      @item.content_type = 'video/quicktime' if File.extname(item).downcase == '.mov'
      @item.content_type = 'audio/mpeg' if File.extname(item).downcase == '.mp3'
      @item.content_type = 'video/mp4' if File.extname(item).downcase == '.mp4'
      @item.content_type = 'video/mpeg' if File.extname(item).downcase == '.mpeg'
      @item.content_type = 'video/mpeg' if File.extname(item).downcase == '.mpg'
      @item.content_type = 'application/pdf' if File.extname(item).downcase == '.pdf'
      @item.content_type = 'image/png' if File.extname(item).downcase == '.png'
      @item.content_type = 'application/x-photoshop' if File.extname(item).downcase == '.psd'
      @item.content_type = 'text/x-python-script' if File.extname(item).downcase == '.py'
      @item.content_type = 'text/x-ruby-script' if File.extname(item).downcase == '.rb'
      @item.content_type = 'text/rtf' if File.extname(item).downcase == '.rtf'
      @item.content_type = 'application/x-shockwave-flash' if File.extname(item).downcase == '.swf'
      @item.content_type = 'image/tiff' if File.extname(item).downcase == '.tif'
      @item.content_type = 'image/tiff' if File.extname(item).downcase == '.tiff'
      @item.content_type = 'text/plain' if File.extname(item).downcase == '.txt'
      @item.content_type = 'audio/x-wav' if File.extname(item).downcase == '.wav'
      @item.content_type = 'video/x-ms-wmv' if File.extname(item).downcase == '.wmv'
      @item.content_type = 'application/vnd.ms-excel' if File.extname(item).downcase == '.xls'
      @item.content_type = 'application/zip' if File.extname(item).downcase == '.zip'
      @item.user_id = 1
      @item.created_at = File.mtime(item)
      @item.updated_at = File.mtime(item)
      puts "Importing file: #{@item.filename}"
      @item.save!
      # hack to allow un-sanatized filenames into the database without attachment_fu interference
      Upload.update_all ['filename = ?', File.basename(item)], ['id = ?', @item.id]
    end
    puts 'Import completed successfully.'
  end
end
