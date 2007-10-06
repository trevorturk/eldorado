# == Schema Information
# Schema version: 62
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
#

class Forum < ActiveRecord::Base
  
  has_many :topics, :order => 'topics.last_post_at', :dependent => :destroy
  has_one :last_topic, :class_name => "Topic", :order => "last_post_at desc"
  belongs_to :category
    
  validates_presence_of :name, :category_id
  validates_uniqueness_of :name, :case_sensitive => false
  
  def updated_at
    last_post_at
  end
  
  def to_s
    name.to_s
  end
  
end
