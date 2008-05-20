class Forum < ActiveRecord::Base
  
  has_many :topics, :order => 'topics.last_post_at desc', :dependent => :destroy
  has_one :last_topic, :class_name => "Topic", :order => "last_post_at desc"
  belongs_to :category
  
  validates_presence_of :name, :category_id
  validates_uniqueness_of :name, :case_sensitive => false
  
  def updated_at
    last_post_at
  end
  
  def to_s
    name
  end
end
