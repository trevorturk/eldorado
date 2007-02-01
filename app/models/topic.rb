class Topic < ActiveRecord::Base
    
  has_many :posts, :order => 'posts.created_at', :dependent => :destroy do
    def last
      @last_post ||= find(:first, :order => 'posts.created_at desc')
    end
  end
  
  belongs_to :user
  
  validates_presence_of :user_id, :title
  
  attr_accessor :body
  
  def hit!
    self.class.increment_counter :views, id
  end
      
end
