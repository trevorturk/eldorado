# == Schema Information
# Schema version: 68
#
# Table name: subscriptions
#
#  id       :integer         not null, primary key
#  user_id  :integer         
#  topic_id :integer         
#

class Subscription < ActiveRecord::Base
  
  def to_s
    id.to_s
  end
  
end
