# == Schema Information
# Schema version: 54
#
# Table name: posts
#
#  id         :integer(11)   not null, primary key
#  user_id    :integer(11)   
#  topic_id   :integer(11)   
#  body       :text          
#  created_at :datetime      
#  updated_at :datetime      
#  updated_by :integer(11)   
#

class Post < ActiveRecord::Base
  
  belongs_to :user,  :counter_cache => true
  belongs_to :topic, :counter_cache => true
  belongs_to :editor, :foreign_key => "updated_by", :class_name => "User"
  
  validates_presence_of :user_id, :body
    
  after_create do |p| 
    @topic = Topic.find(p.topic_id)
    Topic.update_all(['last_post_id = ?, last_post_at = ?, last_post_by = ?', p.id, p.created_at, p.user_id], ['id = ?', @topic.id])
    Forum.update_all(['last_post_id = ?, last_post_at = ?, last_post_by = ?', p.id, p.created_at, p.user_id], ['id = ?', @topic.forum_id])
    Forum.increment_counter("posts_count", @topic.forum_id)
  end
  
  after_destroy do |p| 
    @topic = Topic.find(p.topic.id)
    @post = Post.find(:first, :conditions => ['topic_id = ?', @topic.id], :order => 'created_at desc')
    Topic.update_all(['last_post_id = ?, last_post_at = ?, last_post_by = ?', @post.id, @post.created_at, @post.user_id], ['id = ?', @topic.id])
    Forum.update_all(['last_post_id = ?, last_post_at = ?, last_post_by = ?', @post.id, @post.created_at, @post.user_id], ['id = ?', @topic.forum_id])
    Forum.decrement_counter("posts_count", @topic.forum_id)
  end
  
  attr_accessor :title, :private, :forum_id
  
  attr_accessible :body
  
  def page
    posts = Post.find_all_by_topic_id(self.topic_id, :select => 'id', :order => 'created_at').map(&:id)
    post_number = posts.rindex(self.id) + 1
    (post_number.to_f / Topic::PER_PAGE).ceil
  end
        
end
