# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper  
  
  protected
  
  def random_header_css
    if (current_controller == 'headers' and (current_action == 'edit' or current_action == 'show'))
      @header = Header.find(params[:id])
    else
      @header = Header.find(:first, :order => "RAND()", :conditions => ["votes >= ?", 0])
    end
    if @header
      return '<style type="text/css">.header { background: #333 url("'+@header.public_filename+'"); }</style>'
    end
  end
  
  def login_image_css
    return '<style type="text/css">.login { background: #f1f1f1 url("/files/'+@options.login_image+'") bottom right; }</style>' unless @options.login_image.nil?
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
    image_tag @options.avatars_path + h(user.avatar) unless user.avatar.blank?
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
    end
  end
    
  def current_controller
    request.path_parameters['controller']
  end
  
  def current_action
    request.path_parameters['action']
  end
      
end
