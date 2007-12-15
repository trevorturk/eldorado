# == Schema Information
# Schema version: 67
#
# Table name: settings
#
#  id           :integer(11)     not null, primary key
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
  
  def theme
    read_attribute(:theme) # not sure why this is needed, but tests are failing without it
  end
  
  def to_s
    title.to_s
  end
  
end
