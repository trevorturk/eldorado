class Topic < ActiveRecord::Base
  
  validates_presence_of :user_id, :title
  
  attr_accessor :body
  
  has_many :posts, :order => 'posts.created_at', :dependent => :destroy do
    def last
      @last_post ||= find(:first, :order => 'posts.created_at desc')
    end
  end
  
  def view!
    self.class.increment_counter :views, id
  end
      
end
