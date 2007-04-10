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
      # CATEGORIES
      @items = ActiveRecord::Base.connection.execute('SELECT id, cat_name, disp_position FROM pun_categories')
      ActiveRecord::Base.connection.execute('TRUNCATE table categories')
      for i in @items
        id = i[0] # id 
        name = i[1] # cat_name
        position = i[2] # disp_position
        ActiveRecord::Base.connection.execute("INSERT INTO categories (id, name, position) VALUES ('#{id}', '#{name}', '#{position}');")
      end
      # USERS
      #
      # ignoring the following from PunBB: 
      # group_id, title, realname, url, jabber, icq, msn, aim, yahoo, location, use_avatar, 
      # disp_topics, disp_posts, email_setting, save_pass, notify_with_post, show_smilies, 
      # show_img, show_img_sig, show_avatars, show_sig, timezone, language, style, last_post, 
      # registration_ip, admin_note, activate_string, activate_key, birthday
      #
      # ignoring the following from El Dorado:
      # admin, bio, topics_count, headers_count, events_count, uploads_count
      # banned_until, ban_message, avatars_count, avatar_id, themes_count, theme_id
      #
      @items = ActiveRecord::Base.connection.execute('SELECT id, username, password, email, signature, num_posts, registered, last_visit FROM pun_users')
      ActiveRecord::Base.connection.execute('TRUNCATE table users')
      for i in @items
        id = i[0]
        login = i[1]
        email = i[3]
        password_hash = i[2]
        created_at = i[0]
        last_login_at = i[0]
        posts_count = i[0]
        signature = i[0]
        updated_at = last_login_at
        profile_updated_at = created_at
        online_at = last_login_at
        ActiveRecord::Base.connection.execute("INSERT INTO users (id, name, position) VALUES ('#{id}', '#{name}', '#{position}');")
      end
      # DONE
      flash[:notice] = 'fin'
    end
  end
    
end
