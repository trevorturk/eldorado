class Viewing < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :user_id, :topic_id
  validates_uniqueness_of :user_id, :scope => :topic_id
  
end
