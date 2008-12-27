class Comment < ActiveRecord::Base

  attr_accessible :resource_id, :resource_type, :body
  
  belongs_to :resource, :polymorphic => true, :counter_cache => true
  belongs_to :user
  
  validates_presence_of :user_id, :body, :resource
    
  def self.get(page = 1)
    paginate(:page => page, :order => 'created_at desc', :include => :user)
  end
  
  def to_s
    body
  end
  
end
