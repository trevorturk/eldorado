# == Schema Information
# Schema version: 68
#
# Table name: ranks
#
#  id        :integer         not null, primary key
#  title     :string(255)     
#  min_posts :integer         
#

class Rank < ActiveRecord::Base
  
  def to_s
    title.to_s
  end
  
end
