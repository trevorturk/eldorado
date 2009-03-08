class Post < ActiveRecord::Base
  
  attr_accessible :topic_id, :body, :title, :forum_id, :locked, :sticky, :subscribe
  attr_accessor :title, :forum_id, :locked, :sticky, :subscribe
  
  belongs_to :topic, :counter_cache => true
  belongs_to :user,  :counter_cache => true
  belongs_to :editor, :foreign_key => 'updated_by', :class_name => 'User'
  
  validates_presence_of :user_id, :body
  
  after_create  :update_cached_fields_in_topic, :increment_counter_in_forum, :deliver_subscription
  after_destroy :update_cached_fields_in_topic, :decrement_counter_in_forum
  
  def update_cached_fields_in_topic
    topic.update_cached_fields
  end
  
  def increment_counter_in_forum
    Forum.increment_counter(:posts_count, topic.forum_id)
  end
  
  def decrement_counter_in_forum
    Forum.decrement_counter(:posts_count, topic.forum_id)
  end
  
  def deliver_subscription
    subscribers = topic.subscribers.delete_if {|sub| sub == self.user} # don't include this post's creator
    Mailer.deliver_subscription(subscribers, topic, self) unless subscribers.blank?
  end
  
  def self.get(page = 1)
    paginate(:page => page, :per_page => 15, :order => 'created_at desc', :include => [:topic, :user])
  end
  
  def page
    posts = Post.find_all_by_topic_id(self.topic_id, :select => 'id', :order => 'created_at').map(&:id)
    post_number = posts.rindex(self.id) + 1
    (post_number.to_f / 30).ceil
  end
  
  def to_s
    body
  end
  
end
