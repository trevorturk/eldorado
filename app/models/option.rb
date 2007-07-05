# == Schema Information
# Schema version: 53
#
# Table name: options
#
#  id           :integer(11)   not null, primary key
#  site_title   :string(255)   
#  site_tagline :string(255)   
#  footer_left  :text          
#  footer_right :text          
#  admin_rank   :string(255)   
#  newest_user  :string(255)   
#  theme_id     :integer(11)   
#

class Option < ActiveRecord::Base
end
