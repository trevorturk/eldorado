class Message < ActiveRecord::Base
  
  attr_accessible :body
  
  belongs_to :user
  
  validates_presence_of :body
    
  def self.get(since = Time.now.utc)
    messages = all(:limit => 500, :conditions => ['created_at > ?', since], :order => 'messages.id desc', :include => :user)
    messages = all(:limit => 50, :order => 'messages.id desc', :include => :user) if messages.size < 50
    messages
  end
  
  def self.more(id)
    find(:all, :limit => 100, :order => 'messages.id desc', :include => :user, :conditions => ['messages.id < ?', id])
  end
  
  def self.refresh(id, current_user)
    find(:all, :order => 'messages.id desc', :include => :user, :conditions => ['messages.id > ? and user_id != ?', id, current_user])
  end
  
  def to_s
    body
  end
  
end
