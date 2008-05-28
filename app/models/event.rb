class Event < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :title, :description, :date, :user_id
  
  attr_protected :id, :created_at, :updated_at 
  
  named_scope :reminders, lambda {|*args| {:conditions => {:reminder => true, :date => Time.now.utc-2.hours..Time.now.utc+6.hours}, :order => 'date asc'}}
  
  def to_s
    title
  end
end
