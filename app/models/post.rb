class Post < ActiveRecord::Base
  
  belongs_to :user,  :counter_cache => true
  belongs_to :topic, :counter_cache => true
    
  validates_presence_of :user_id, :body

  after_create  { |r| Topic.update_all(['last_post_id = ?, last_post_at = ?, last_post_by = ?', r.id, r.created_at, r.user_id], ['id = ?', r.topic_id]) }
  
  attr_accessor :title
  
end
