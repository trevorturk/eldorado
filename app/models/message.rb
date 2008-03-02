# == Schema Information
# Schema version: 73
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

  def to_s
    body.to_s
  end
  
end
