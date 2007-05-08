class Event < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :title, :description, :date
      
end
