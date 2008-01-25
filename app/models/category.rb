# == Schema Information
# Schema version: 68
#
# Table name: categories
#
#  id       :integer         not null, primary key
#  name     :string(255)     
#  position :integer         default(0)
#

class Category < ActiveRecord::Base
  
  has_many :forums, :order => 'forums.position', :dependent => :destroy
  
  validates_presence_of     :name, :position
  validates_uniqueness_of   :name, :case_sensitive => false
  
  def to_s
    name.to_s
  end
  
end
