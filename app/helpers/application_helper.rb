# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper  
  
  protected
  
  def random_header_css
    if current_controller == 'headers' and (current_action == 'edit' or current_action == 'show')
      @header = Header.find(params[:id])
    else
      @header = Header.find(:first, :order => "RAND()", :conditions => ["votes >= ?", 0])
    end    
    return '<style type="text/css">.header { background: #333 url("'+@header.public_filename+'"); }</style>' if @header
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
    # if (current_action != "new") ; h(item.name) + " (" + h(@options.site_title) + ")"
    h(@options.site_title)
  end
  
  def avatar_for(user)
    if !user.avatar_id.blank?
      @avatar = Avatar.find(user.avatar_id)
      image_tag @avatar.public_filename
    end
  end
  
  def rank_for(posts_count, admin)
    return @options.admin_rank if admin == true
    @ranks ||=  Rank.find(:all, :order => "min_posts")
    return "Member" if @ranks.nil?
    for rank in @ranks
		  @rank = rank if posts_count >= rank.min_posts
    end
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
    return '<div class="icon"><!-- --></div>' unless logged_in?
    return '<div class="icon"><!-- --></div>' if current_item.updated_at.nil?
    return '<div class="icon inew"><!-- --></div>' if session[:last_session_at] < current_item.updated_at
    return '<div class="icon"><!-- --></div>'
  end
        
  def current_controller
    request.path_parameters['controller']
  end
  
  def current_action
    request.path_parameters['action']
  end
      
end
