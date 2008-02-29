# == Schema Information
# Schema version: 72
#
# Table name: ranks
#
#  id        :integer(11)     not null, primary key
#  title     :string(255)     
#  min_posts :integer(11)     
#

class Rank < ActiveRecord::Base
  
  def to_s
    title.to_s
  end
  
end
