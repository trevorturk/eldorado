# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper  
  
  def random_string
    char = ("a".."z").to_a + ("1".."9").to_a 
    Array.new(6, '').collect{char[rand(char.size)]}.join
  end
    
  protected
  
  def random_header_css
    if current_controller == 'headers' and (current_action == 'edit' or current_action == 'show')
      @header = Header.find(params[:id])
    else
      @header = Header.find(:first, :order => "RAND()", :conditions => ["votes >= ?", 0])
    end    
    return '<style type="text/css">.header { background: #333 url("'+@header.public_filename+'"); }</style>' if @header
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
    page_title = h(@options.site_title)
    page_title << ': ' + @topic.title unless @topic.nil? or @topic.title.nil?
    page_title << ': ' + @user.login unless @user.nil? or @user.login.nil?
    page_title << ': ' + @event.title unless @event.nil? or @event.title.nil?
    page_title << ': ' + @header.filename unless @header.nil? or @header.filename.nil?
    return page_title
  end
  
  def avatar_for(user)
    if !user.avatar_id.blank?
      @avatar = Avatar.find(user.avatar_id)
      image_tag @avatar.public_filename
    end
  end
  
  def rank_for(posts_count, admin)
    return @options.admin_rank if admin
    @ranks ||=  Rank.find(:all, :order => "min_posts")
    return "Member" if @ranks.blank?
    for r in @ranks
		  @rank = r if posts_count >= r.min_posts
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
    return '<div class="icon inew"><!-- --></div>' if session[:online_at] < current_item.updated_at
    return '<div class="icon"><!-- --></div>'
  end
  
  def bb(text)
    text = simple_format(bbcodeize(white_list(h(text))))
    auto_link(text) do |t|
      truncate(t, 30)
    end
  end
    
  def current_controller
    request.path_parameters['controller']
  end
  
  def current_action
    request.path_parameters['action']
  end
  
  def distance_of_time_in_words(from_time, to_time = 0, include_seconds = true)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round
    distance_in_seconds = ((to_time - from_time).abs).round
    case distance_in_minutes
      when 0..1           then (distance_in_seconds < 60) ? "#{distance_in_seconds} seconds ago" : '1 minute ago'
      when 2..59          then "#{distance_in_minutes} minutes ago"
      when 60..90         then "1 hour ago"
      when 90..1440       then "#{(distance_in_minutes.to_f / 60.0).round} hours ago"
      when 1440..2160     then '1 day ago' # 1 day to 1.5 days
      when 2160..2880     then "#{(distance_in_minutes.to_f / 1440.0).round} days ago" # 1.5 days to 2 days
      # when 2880..10080    then from_time.strftime("%a, %d %b") # up to 1 week
      else from_time.strftime("%a, %d %b %Y")
    end
  end
      
end
