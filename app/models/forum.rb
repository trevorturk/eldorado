# == Schema Information
# Schema version: 53
#
# Table name: forums
#
#  id           :integer(11)   not null, primary key
#  category_id  :integer(11)   
#  name         :string(255)   
#  description  :text          
#  topics_count :integer(11)   default(0)
#  posts_count  :integer(11)   default(0)
#  position     :integer(11)   default(0)
#  last_post_id :integer(11)   
#  last_post_at :datetime      
#  last_post_by :integer(11)   
#

class Forum < ActiveRecord::Base
  
  has_many :topics, :order => 'last_post_at', :dependent => :destroy
  belongs_to :category
  
  belongs_to :last_poster, :foreign_key => "last_post_by", :class_name => "User"
  
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  
  def updated_at
    last_post_at
  end
  
end
