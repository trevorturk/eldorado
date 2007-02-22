class Post < ActiveRecord::Base
  
  belongs_to :user,  :counter_cache => true
  belongs_to :topic, :counter_cache => true
  belongs_to :editor, :foreign_key => "updated_by", :class_name => "User"
  
  validates_presence_of :user_id, :body
    
  after_create  { |t| Topic.update_all(['last_post_id = ?, last_post_at = ?, last_post_by = ?', t.id, t.created_at, t.user_id], ['id = ?', t.topic_id]) }
  
  attr_accessor :title
  attr_accessor :private
  
  attr_protected :user_id, :topic_id, :created_at, :updated_at, :updated_by
    
  def can_edit_post?(user)
    user.admin? || (user.id == user_id) || (user.id == topic.user_id)
  end
  
end
