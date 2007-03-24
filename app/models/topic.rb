class Topic < ActiveRecord::Base
    
  has_many :posts, :order => 'posts.created_at', :dependent => :destroy 
  belongs_to :user, :counter_cache => true
  belongs_to :forum, :counter_cache => true
  belongs_to :last_poster, :foreign_key => "last_post_by", :class_name => "User"
  
  validates_presence_of :user_id, :title, :forum_id
    
  attr_accessor :body
  
  attr_protected :user_id, :created_at, :updated_at, :views, :posts_count, :last_post_id, :last_post_at, :last_post_by
      
  def hit!
    self.class.increment_counter :views, id
  end
  
  def posters
    posts.map { |p| p.user_id }.uniq.size
  end
  
  def can_edit_topic?(user)
    user.admin? || (user.id == user_id)
  end
  
end
