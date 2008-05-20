class Post < ActiveRecord::Base
  
  belongs_to :user,  :counter_cache => true
  belongs_to :topic, :counter_cache => true
  belongs_to :editor, :foreign_key => "updated_by", :class_name => "User"
  
  validates_presence_of :user_id, :body
  
  attr_accessor :title, :forum_id, :locked, :sticky

  def page
    posts = Post.find_all_by_topic_id(self.topic_id, :select => 'id', :order => 'created_at').map(&:id)
    post_number = posts.rindex(self.id) + 1
    (post_number.to_f / Topic::PER_PAGE).ceil
  end
  
  def after_create
    topic.update_cached_fields
    Forum.increment_counter("posts_count", topic.forum_id)
  end

  def after_destroy
    topic.update_cached_fields
    Forum.decrement_counter("posts_count", topic.forum_id)
  end
  
  def to_s
    body
  end
end
