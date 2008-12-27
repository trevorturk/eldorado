class Rank < ActiveRecord::Base
  
  attr_accessible :title, :min_posts
  
  validates_presence_of :title, :min_posts
  validates_uniqueness_of :title, :min_posts
  validates_numericality_of :min_posts
  
  def to_s
    title
  end
  
end
