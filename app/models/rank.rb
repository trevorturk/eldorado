# == Schema Information
# Schema version: 75
#
# Table name: ranks
#
#  id        :integer(11)     not null, primary key
#  title     :string(255)     
#  min_posts :integer(11)     
#

class Rank < ActiveRecord::Base
  
  validates_presence_of :title, :min_posts
  validates_uniqueness_of :title, :min_posts
  validates_numericality_of :min_posts
  
  def to_s
    title
  end
end
