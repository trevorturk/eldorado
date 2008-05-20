class Event < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :title, :description, :date, :user_id
  
  attr_protected :id, :created_at, :updated_at 
      
  def self.reminders
    find(:all, :order => 'date asc', :conditions => { :reminder => true, :date => Time.now.utc-2.hours..Time.now.utc+8.hours })
  end
  
  def to_s
    title
  end
end
