class Forum < ActiveRecord::Base
  
  has_many :topics, :order => 'last_post_at', :dependent => :destroy
  belongs_to :category
  
  belongs_to :last_poster, :foreign_key => "last_post_by", :class_name => "User"
  
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  
  def last_updated_at
    last_post_at
  end
  
end
