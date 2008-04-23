# == Schema Information
# Schema version: 74
#
# Table name: events
#
#  id          :integer(11)     not null, primary key
#  title       :string(255)     
#  description :text            
#  date        :datetime        
#  reminder    :boolean(1)      
#  user_id     :integer(11)     
#  created_at  :datetime        
#  updated_at  :datetime        
#

class Event < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :title, :description, :date, :user_id
  
  attr_protected :id, :created_at, :updated_at 
  
  tz_time_attributes :date
    
  def self.reminders
    find(:all, :order => 'date asc', :conditions => { :reminder => true, :date => Time.now-2.hours..Time.now+8.hours })
  end
  
  def to_s
    title
  end
end
