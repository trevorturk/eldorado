class Event < ActiveRecord::Base
  
  belongs_to :user, :counter_cache => true
  
  validates_presence_of :title, :description, :date
    
end
