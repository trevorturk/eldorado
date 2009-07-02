class Setting < ActiveRecord::Base
  
  attr_accessible :title, :tagline, :announcement, :footer, :theme, :favicon, :time_zone, :private, :login_message, :admin_only_create
    
  validates_presence_of :time_zone
      
  def theme
    read_attribute(:theme) # TODO not sure why this is needed, but tests are failing without it
  end
  
  def self.defaults
    Setting.new(
      :title => I18n.translate(:el_dorado),
      :tagline => I18n.translate(:tagline),
      :footer => "<p style=\"text-align:right;margin:0;\">#{I18n.translate(:powered_by)} <a href=\"http://almosteffortless.com/eldorado/\">#{I18n.translate(:el_dorado)}</a></p>",
      :login_message => I18n.translate(:login_message),
      :time_zone => 'UTC'
    ).save
  end
  
  def self.current_theme
    current_url = Setting.first.theme
    Theme.all.detect {|t| t.attachment.url == current_url }
  end
  
  def to_s
    title
  end
  
end
