# == Schema Information
# Schema version: 63
#
# Table name: options
#
#  id           :integer(11)   not null, primary key
#  title        :string(255)   
#  tagline      :string(255)   
#  announcement :text          
#  footer       :text          
#  theme_id     :integer(11)   
#  favicon      :string(255)   
#

class Option < ActiveRecord::Base
  
  def to_s
    title.to_s
  end
  
end
