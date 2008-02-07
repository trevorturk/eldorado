# == Schema Information
# Schema version: 69
#
# Table name: topics
#
#  id           :integer(11)     not null, primary key
#  user_id      :integer(11)     
#  title        :string(255)     
#  created_at   :datetime        
#  views        :integer(11)     default(0)
#  posts_count  :integer(11)     default(0)
#  last_post_id :integer(11)     
#  last_post_at :datetime        
#  last_post_by :integer(11)     
#  private      :boolean(1)      
#  locked       :boolean(1)      
#  sticky       :boolean(1)      
#  forum_id     :integer(11)     
#

class Topic < ActiveRecord::Base
    
  has_many :posts, :order => 'posts.created_at', :dependent => :destroy 
  has_many :posters, :through => :posts, :source => :user, :uniq => true
  belongs_to :user
  belongs_to :forum, :counter_cache => true
  belongs_to :last_post, :foreign_key => "last_post_id", :class_name => "Post"
  belongs_to :last_poster, :foreign_key => "last_post_by", :class_name => "User"
  
  validates_presence_of :user_id, :title, :forum_id
    
  attr_accessor :body
  
  # attr_accessible :title, :private, :locked, :sticky, :forum_id, :body
  
  PER_PAGE = 30
  
  def hit!
    self.class.increment_counter :views, id
  end
  
  def posters
    posts.map { |p| p.user_id }.uniq.size
  end
  
  def updated_at
    last_post_at
  end
  
  def replies 
    self.posts_count - 1
  end
  
  def last_page
    [(posts_count.to_f / PER_PAGE).ceil.to_i, 1].max
  end
  
  def update_cached_fields
    post = posts.find(:first, :order => 'posts.created_at desc')
    return if post.nil? # return if this was the last post in the thread
    self.class.update_all(['last_post_id = ?, last_post_at = ?, last_post_by = ?', post.id, post.created_at, post.user_id], ['id = ?', self.id])
  end
  
  def to_s
    title.to_s
  end
    
end
