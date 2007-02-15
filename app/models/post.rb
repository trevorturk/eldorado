class Post < ActiveRecord::Base
  
  belongs_to :user,  :counter_cache => true
  belongs_to :topic, :counter_cache => true
  belongs_to :editor, :foreign_key => "updated_by", :class_name => "User"
  
  validates_presence_of :user_id, :body

  after_create  { |r| Topic.update_all(['last_post_id = ?, last_post_at = ?, last_post_by = ?', r.id, r.created_at, r.user_id], ['id = ?', r.topic_id]) }
  
  attr_accessor :title
  
  def can_edit_post?(current_user)
    (current_user.id == user_id) || (current_user.id == topic.user_id) || (current_user.admin == true)
  end
  
end
