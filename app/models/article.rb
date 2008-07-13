class Article < ActiveRecord::Base
  
  belongs_to :user, :counter_cache => true
  
  validates_presence_of :user_id, :title, :body
  attr_readonly :user_id, :created_at
  
  def self.get(limit = 15)
    find(:all, :limit => limit, :order => 'created_at desc', :include => :user)
  end
  
  def to_s
    title
  end
end
