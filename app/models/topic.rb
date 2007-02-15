class Topic < ActiveRecord::Base
    
  has_many :posts, :order => 'posts.created_at', :dependent => :destroy 
  belongs_to :user, :counter_cache => true
  belongs_to :last_poster, :foreign_key => "last_post_by", :class_name => "User"
  
  validates_presence_of :user_id, :title
  
  attr_accessor :body
  
  def hit!
    self.class.increment_counter :views, id
  end
  
  def can_edit_topic?(current_user)
    (current_user.id == user_id) || (current_user.admin == true)
  end
  
end