class Comment < ActiveRecord::Base
  
  belongs_to :resource, :polymorphic => true, :counter_cache => true
  
  def to_s
    body
  end
end
