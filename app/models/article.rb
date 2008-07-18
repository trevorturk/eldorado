class Article < ActiveRecord::Base
  
  belongs_to :user, :counter_cache => true
  
  validates_presence_of :user_id, :title, :body
  attr_readonly :user_id, :created_at
  
  def self.get(page = 1)
    paginate(:page => page, :per_page => 15, :order => 'created_at desc', :include => :user)
  end
  
  def to_s
    title
  end
end
