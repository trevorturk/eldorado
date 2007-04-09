# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper  
  
  protected
  
  def random_header_css
    if (current_controller == 'headers' and current_action == ('edit' or 'show'))
      @header = Header.find(params[:id])
    else
      @header = Header.find(:first, :order => "RAND()", :conditions => ["votes >= ?", 0])
    end
    if @header
      return '<style type="text/css">.header { background: #333 url("'+@header.public_filename+'"); }</style>'
    end
  end
  
  def login_image_css
    return '<style type="text/css">.login { background: #f1f1f1 url("/files/'+@options.login_image+'") bottom right no-repeat; }</style>' unless @options.login_image.nil?
  end
  
  def theme_css
    if @options.theme_id.nil?
      return '<style type="text/css">@import "/stylesheets/application.css";</style>'
    else
      @theme = Theme.find(@options.theme_id) 
      return '<style type="text/css">@import "'+@theme.public_filename+'";</style>'
    end
  end

  def page_title
    if @topic && (current_action != "new")
      h(@topic.title) + " (" + h(@options.site_title) + ")"
    elsif @user && (current_action != "new") && logged_in?
      h(@user.login) + " (" + h(@options.site_title) + ")"
    else
      h(@options.site_title)
    end
  end
  
  def avatar_img(user)
    if !user.avatar_id.blank?
      @avatar = Avatar.find(user.avatar_id)
      image_tag @avatar.public_filename
    end
  end
  
  def rank_for(posts_count, admin)
    @rank = Ranks.find(:first, :order => "min_posts desc", :conditions => ["? >= min_posts", posts_count])
    return @options.admin_rank if admin == true
    return "Member" if @rank.nil?
    return h(@rank.title)
  end
  
  def tab(name)
    if name == current_controller
      'tab'
    elsif name == "forums" && ((current_controller == "categories") || (current_controller == "topics") || (current_controller == "posts"))
      'tab'
    elsif name == "users" && ((current_controller == "avatars") || (current_controller == "themes"))
      'tab'
    end
  end
  
  def can_edit?(current_item)
    return false unless logged_in?
    if current_controller == "users"
      return current_user.admin? || (current_user.id == current_item.id) 
    else
      return current_user.admin? || (current_user.id == current_item.user_id) 
    end
  end
  
  def icon_for(current_item)
    return '' unless logged_in?
    if (current_controller == "users" and session[:last_session_at] < current_item.profile_updated_at)
      return '<div class="icon inew"></div>'
    elsif ((current_controller == "topics" or current_controller == "forums" or current_controller == "categories" or current_controller == "home") and (session[:last_session_at] < current_item.last_post_at))
      return '<div class="icon inew"></div>'
    else
      return '<div class="icon"> </div>'
    end
  end
    
  def current_controller
    request.path_parameters['controller']
  end
  
  def current_action
    request.path_parameters['action']
  end
      
end
