class Event < ActiveRecord::Base
  
  belongs_to :user, :counter_cache => true
  
  validates_presence_of :title, :description, :date
  
  def can_edit_event?(user)
    user.admin? || (user.id == user_id)
  end
  
end
