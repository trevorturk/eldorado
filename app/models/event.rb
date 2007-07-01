# == Schema Information
# Schema version: 52
#
# Table name: events
#
#  id          :integer(11)   not null, primary key
#  title       :string(255)   
#  description :text          
#  date        :datetime      
#  private     :boolean(1)    
#  reminder    :boolean(1)    
#  user_id     :integer(11)   
#  created_at  :datetime      
#  updated_at  :datetime      
#  location    :text          
#

class Event < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :title, :description, :date
  
  attr_protected :id, :user_id, :created_at, :updated_at 
  
end
