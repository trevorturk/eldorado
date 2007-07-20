# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper  
  
  def random_string
    char = ("a".."z").to_a + ("1".."9").to_a 
    Array.new(6, '').collect{char[rand(char.size)]}.join
  end
    
  protected
  
  def random_header_css
    if current_controller == 'headers' && (current_action == 'edit' || current_action == 'show')
      @header = Header.find(params[:id])
    else
      @header = Header.find(:first, :order => :random, :conditions => ["votes >= ?", 0])
    end    
    return '<style type="text/css">.header { background: #333 url("' + @header.public_filename + '"); }</style>' if @header
  end
    
  def theme_css
    if @options.theme_id.nil?
      return '<style type="text/css">@import "/stylesheets/application.css";</style>'
    else
      @theme = Theme.find(@options.theme_id) 
      return '<style type="text/css">@import "' + @theme.public_filename + '";</style>'
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
    image_tag user.avatar unless user.avatar.nil?
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

  def is_new?(item)
    return false unless logged_in?
    return true if session[:online_at] < item.updated_at
  end
  
  def icon_for(item)
    return '<div class="icon inew"><!-- --></div>' if is_new?(item)
    return '<div class="icon"><!-- --></div>'
  end
    
  def bb(text)
    text = simple_format(bbcodeize(white_list(h(text))))
    auto_link(text) do |t|
      truncate(t)
    end
  end
  
  def tz(time_at)
    TzTime.zone.utc_to_local(time_at.utc).strftime("%a, %d %b %Y %H:%M:%S")
  end
  
  def convert_tz(t)
    t = '+' + t.to_s if t == t.abs # add a plus sign if a positive number
    t = '' if t == '+0' # clear timezone if it's 0, will end up being GMT
    t = 'Etc/GMT' + t.to_s # this will have a minus sign if it's negative
  end
    
  def current_controller
    request.path_parameters['controller']
  end
  
  def current_action
    request.path_parameters['action']
  end
  
  def distance_of_time_in_words(from_time, to_time = 0, include_seconds = true, detail = false)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round
    distance_in_seconds = ((to_time - from_time).abs).round
    case distance_in_minutes
      when 0..1           then time = (distance_in_seconds < 60) ? "#{pluralize(distance_in_seconds, 'second')} ago" : '1 minute ago'
      when 2..59          then time = "#{distance_in_minutes} minutes ago"
      when 60..90         then time = "1 hour ago"
      when 90..1440       then time = "#{(distance_in_minutes.to_f / 60.0).round} hours ago"
      when 1440..2160     then time = '1 day ago' # 1 day to 1.5 days
      when 2160..2880     then time = "#{(distance_in_minutes.to_f / 1440.0).round} days ago" # 1.5 days to 2 days
      else time = from_time.strftime("%a, %d %b %Y")
    end
    return from_time.strftime("%a, %d %b %Y %H:%M:%S") if (detail && distance_in_minutes > 2880)
    return time
  end
      
end
