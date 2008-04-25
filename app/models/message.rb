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
  
  tz_time_attributes :created_at
  
  def self.recent(limit)
    find(:all, :limit => limit, :include => [:user], :order => 'messages.created_at desc')
  end
  
  def self.refresh(message_id, current_user)
    find(:all, :order => 'created_at desc', :conditions => ['id > ? and user_id != ?', message_id, current_user])
  end
  
  def to_s
    body
  end
end
