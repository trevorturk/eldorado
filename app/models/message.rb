# == Schema Information
# Schema version: 76
#
# Table name: messages
#
#  id         :integer(11)     not null, primary key
#  user_id    :integer(11)     
#  body       :text            
#  created_at :datetime        
#

class Message < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :body
  
  # TODO can remove w/ rails 2.1
  def self.last
    find(:first, :order => 'id desc')
  end
    
  def self.get
    find(:all, :limit => 50, :order => 'messages.id desc', :include => :user)
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