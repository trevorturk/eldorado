class Setting < ActiveRecord::Base
  
  validates_presence_of :time_zone
    
  TITLE = 'El Dorado'
  TAGLINE = 'A full-stack community web application written in Ruby/Rails'
  FOOTER = '<p style="text-align:right;margin:0;">Powered by <a href="http://almosteffortless.com/eldorado/">El Dorado</a></p>'
  LOGIN_MESSAGE = 'You are not logged in'
  TIME_ZONE = 'UTC'
  
  def theme
    read_attribute(:theme) # TODO not sure why this is needed, but tests are failing without it
  end
  
  def self.defaults
    Setting.new(:title => TITLE, :tagline => TAGLINE, :footer => FOOTER, :login_message => LOGIN_MESSAGE, :time_zone => TIME_ZONE).save
  end
  
  def to_s
    title
  end
end
