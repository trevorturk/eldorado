class Category < ActiveRecord::Base
  
  has_many :forums, :order => 'forums.position'
  
  validates_presence_of     :name
  validates_uniqueness_of   :name, :case_sensitive => false
  
end
