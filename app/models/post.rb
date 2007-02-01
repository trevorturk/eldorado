class Post < ActiveRecord::Base
  
  belongs_to :user,  :counter_cache => true
  belongs_to :topic, :counter_cache => true
    
  validates_presence_of :user_id, :body

  after_create  { |r| Topic.update_all(['last_post_id = ?', r.id], ['id = ?', r.topic_id]) }
  
  attr_accessor :title
  
end
