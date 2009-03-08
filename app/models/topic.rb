class Topic < ActiveRecord::Base
    
  attr_accessible :title, :locked, :sticky, :forum_id, :body, :subscribe
  attr_accessor :body, :subscribe
  
  belongs_to :forum, :counter_cache => true
  belongs_to :user
  belongs_to :last_post, :foreign_key => "last_post_id", :class_name => "Post"
  belongs_to :last_poster, :foreign_key => "last_post_by", :class_name => "User"
  has_many :posts, :order => 'posts.created_at asc', :dependent => :destroy
  has_many :subscriptions, :dependent => :destroy
  has_many :subscribers, :through => :subscriptions, :source => 'user'
  has_many :viewings, :dependent => :destroy, :order => 'updated_at desc'
  
  validates_presence_of :user_id, :title, :forum_id    
    
  def after_create
    subscriptions.create :user_id => user.id if subscribe.to_i == 1
  end
      
  def before_update
    @old_forum = Topic.find(id).forum
  end
  
  def after_update
    return if @old_forum == forum
    Forum.update_all(['topics_count = ?, posts_count = ?', @old_forum.topics_count-1, @old_forum.posts_count-self.posts.count], ['id = ?', @old_forum.id])
    Forum.update_all(['topics_count = ?, posts_count = ?', forum.topics_count+1, forum.posts_count+self.posts.count], ['id = ?', forum.id])
  end
  
  def self.get(page = 1, per_page = 30, conditions = nil)
    paginate(:page => page, :include => [:user, :forum, :last_poster, :viewings], :per_page => per_page, :conditions => conditions, :order => 'topics.last_post_at desc')    
  end
  
  def viewed_by(user)
    viewing = user.viewings.find_or_create_by_topic_id(self.id)      
    viewing.update_attribute(:updated_at, Time.now)
  end
  
  def hit!
    self.class.increment_counter(:views, id)
  end
  
  def replies
    self.posts_count - 1
  end
  
  def last_page
    [(posts_count.to_f / 30).ceil.to_i, 1].max
  end
  
  def update_cached_fields
    post = posts.find(:first, :order => 'posts.created_at desc')
    return if post.nil? # return if this was the last post in the thread
    self.class.update_all(['last_post_id = ?, last_post_at = ?, last_post_by = ?', post.id, post.created_at, post.user_id], ['id = ?', self.id])
  end
  
  def updated_at
    last_post_at
  end
  
  def to_s
    title
  end
  
  def to_param
    "#{id}-#{to_s.parameterize}"
  end
  
end
