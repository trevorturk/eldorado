class Category < ActiveRecord::Base
  
  has_many :forums, :order => 'forums.position', :dependent => :destroy
  
  validates_presence_of     :name, :position
  validates_uniqueness_of   :name, :case_sensitive => false
  
  def to_s
    name
  end
  
  def to_param
    "#{id}-#{name.gsub(/\W/,'-')}"
  end
  
end
