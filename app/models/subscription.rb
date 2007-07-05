# == Schema Information
# Schema version: 53
#
# Table name: subscriptions
#
#  id       :integer(11)   not null, primary key
#  user_id  :integer(11)   
#  topic_id :integer(11)   
#

class Subscription < ActiveRecord::Base
end
