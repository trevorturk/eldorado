# == Schema Information
# Schema version: 72
#
# Table name: settings
#
#  id            :integer(11)     not null, primary key
#  title         :string(255)     
#  tagline       :string(255)     
#  announcement  :text            
#  footer        :text            
#  theme         :string(255)     
#  favicon       :string(255)     
#  time_zone     :string(255)     default("UTC")
#  private       :boolean(1)      
#  login_message :string(255)     default("You are not logged in")
#

class Setting < ActiveRecord::Base
  
  validates_presence_of :time_zone
  
  composed_of :tz, :class_name => 'TZInfo::Timezone', :mapping => %w( time_zone time_zone )
  
  TITLE = 'El Dorado'
  TAGLINE = 'A full-stack community web application written in Ruby/Rails'
  FOOTER = '<p style="text-align:right;margin:0;">Powered by <a href="http://almosteffortless.com/eldorado/">El Dorado</a> | <a href="http://almosteffortless.com">&aelig;</a></p>'
  LOGIN_MESSAGE = 'You are not logged in'
  
  def theme
    read_attribute(:theme) # not sure why this is needed, but tests are failing without it
  end
  
  def self.defaults
    @settings = Setting.new(:title => TITLE, :tagline => TAGLINE, :footer => FOOTER, :login_message => LOGIN_MESSAGE)
    @settings.save
    @settings
  end
  
  def to_s
    title.to_s
  end
  
end
