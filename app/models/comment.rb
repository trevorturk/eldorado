class Comment < ActiveRecord::Base
  
  belongs_to :resource, :polymorphic => true, :counter_cache => true
  belongs_to :user
  
  validates_presence_of :user_id, :body, :resource
  
  def to_s
    body
  end
end
