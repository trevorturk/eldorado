# == Schema Information
# Schema version: 56
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
  
  validates_presence_of :title, :description, :date, :user_id
  
  attr_protected :id, :created_at, :updated_at 
      
end
