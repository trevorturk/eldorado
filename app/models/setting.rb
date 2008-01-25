# == Schema Information
# Schema version: 68
#
# Table name: settings
#
#  id           :integer         not null, primary key
#  title        :string(255)     
#  tagline      :string(255)     
#  announcement :text            
#  footer       :text            
#  theme        :string(255)     
#  favicon      :string(255)     
#  time_zone    :string(255)     default("UTC")
#

class Setting < ActiveRecord::Base
  
  validates_presence_of :time_zone
  
  composed_of :tz, :class_name => 'TZInfo::Timezone', :mapping => %w( time_zone time_zone )
  
  DEFAULT_TITLE   = 'El Dorado'
  DEFAULT_TAGLINE = 'A full-stack community web application written in Ruby/Rails'
  DEFAULT_FOOTER  = '<p style="text-align:right;margin:0;">Powered by El Dorado | <a href="http://almosteffortless.com">&aelig;</a></p>'
  
  def theme
    read_attribute(:theme) # not sure why this is needed, but tests are failing without it
  end
  
  def self.defaults
    @settings = Setting.new(:title => DEFAULT_TITLE, :tagline => DEFAULT_TAGLINE, :footer => DEFAULT_FOOTER)
    @settings.save
    @settings
  end
  
  def to_s
    title.to_s
  end
  
end
