module ApplicationHelper

  def random_string
    char = ("a".."z").to_a + ("1".."9").to_a
    Array.new(6, '').collect{char[rand(char.size)]}.join
  end

  protected

  def header_image_path
    if current_controller == 'headers' && %w(edit show).include?(current_action)
      @header = Header.find(params[:id])
    else
      @header = Header.random
    end
    @header and @header.attachment.url or "/images/eldorado.jpg"
  end

  def header_css
    if @settings.clickable_header
      return ""
    else
      return "<style type=\"text/css\">.header { background: url('#{header_image_path}'); }</style>"
    end
  end

  def theme_css
    return "<style type=\"text/css\">@import url('/stylesheets/application.css');</style>" if @settings.theme.blank?
    return "<style type=\"text/css\">@import url('#{@settings.theme}');</style>"
  end

  def page_title
    item = [@article, @category, @event, @forum, @header, @message, @topic, @user].compact.first if %w(show edit).include?(current_action)
    page = request.env['PATH_INFO'].delete('/').sub('new','').capitalize unless request.env['PATH_INFO'].nil?
    page = @settings.tagline if current_controller == 'home'
    "#{@settings.title}: #{item || page}"
  end

  def favicon_tag
    return "<link rel=\"shortcut icon\" href=\"#{@settings.favicon}\" />\n" unless @settings.favicon.blank?
  end

  def avatar_for(user)
    image_tag user.avatar unless user.avatar.nil?
  end

  def rank_for(user)
    return I18n.t(:rank_administrator) if user.admin
    return I18n.t(:rank_banned) if user.banned?
    @ranks ||=  Rank.find(:all, :order => "min_posts")
    return I18n.t(:rank_member) if @ranks.blank?
    for r in @ranks
      @rank = r if user.posts_count >= r.min_posts
    end
    return I18n.t(:rank_member) if @rank.nil? # if no ranks are low enough
    return h(@rank.title)
  end

  def tab(name)
    if name == current_controller
      'current_tab'
    elsif name == "forums" && %w(categories topics posts).include?(current_controller)
      'current_tab'
    elsif name == "users" && (current_controller == "avatars" || current_controller == "ranks")
      'current_tab'
    end
  end

  def enabled?(name)
    return true if CONFIG['disabled_tabs'].nil?
    !CONFIG['disabled_tabs'].include?(name)
  end

  def is_new?(item)
    return false unless logged_in?
    if item.is_a?(Topic)
      viewing = item.viewings.select {|v| v.user_id == current_user.id}.first
      (viewing.nil? || viewing.updated_at < item.updated_at) && current_user.all_viewed_at < item.updated_at
    else
      session[:online_at] < item.updated_at
    end
  end

  def icon_for(item)
    if item && is_new?(item)
      '<div class="icon inew"><!-- --></div>'
    else
      '<div class="icon"><!-- --></div>'
    end
  end

  def bb(text)
    auto_link(simple_format(bbcodeize(sanitize(h(text))))) {|t| truncate(t, :length => 50)}
  end

  def current_page(collection)
    I18n.t(:page)+' ' + number_with_delimiter(collection.current_page).to_s + ' ' + I18n.t(:of) + ' ' + number_with_delimiter(collection.total_pages).to_s unless collection.total_pages == 0
  end

  def prev_page(collection)
    unless collection.current_page == 1 or collection.total_pages == 0
      link_to('&laquo; '+I18n.t(:previous_page), { :page => collection.previous_page }.merge(params.reject{|k,v| k=='page'}))
    end
  end

  def next_page(collection)
    unless collection.current_page == collection.total_pages or collection.total_pages == 0
      link_to(I18n.t(:next_page)+' &raquo;', { :page => collection.next_page }.merge(params.reject{|k,v| k=='page'}))
    end
  end

  def t_no_of(item, count = 0)
    I18n.t item, :count => count, :print_count => number_with_delimiter(count)
  end

  def time_ago_or_time_stamp(from_time, to_time = Time.now.utc, include_seconds = true, detail = false)
    return '&ndash;' if from_time.nil?
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs) / 60).round
    distance_in_seconds = ((to_time - from_time).abs).round
    case distance_in_minutes
    when 0..1           then time = (distance_in_seconds < 60) ? I18n.t(:x_seconds_ago, :count => distance_in_seconds, :scope => 'datetime.distance_in_words' ) : I18n.t(:x_minutes_ago, :count => 1, :scope => 'datetime.distance_in_words' )
      when 2..59          then time = I18n.t(:x_minutes_ago, :count => distance_in_minutes, :scope => 'datetime.distance_in_words' )
      when 60..90         then time = I18n.t(:x_hours_ago, :count => 1, :scope => 'datetime.distance_in_words' )
      when 90..1440       then time = I18n.t(:x_hours_ago, :count => (distance_in_minutes.to_f / 60.0).round, :scope => 'datetime.distance_in_words' )
      when 1440..2160     then time = I18n.t(:x_days_ago, :count => 1, :scope => 'datetime.distance_in_words' )
      when 2160..2880     then time = I18n.t(:x_days_ago, :count => (distance_in_minutes.to_f / 1440.0).round, :scope => 'datetime.distance_in_words' )  # 1.5 days to 2 days
      else time = I18n.l(from_time, :format => :ed_date_only)  #from_time.strftime("%a, %d %b %Y")
    end
    return time_stamp(from_time) if (detail && distance_in_minutes > 2880)
    return time
  end

  def time_stamp(time, short = false)
    I18n.l(time, :format => ( short ? :ed_timestamp_short : :ed_timestamp ) )
  end
end