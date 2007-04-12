class Event < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :title, :description, :date
  
  def last_updated_at
    updated_at
  end
    
end
