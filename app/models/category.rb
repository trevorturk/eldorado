# == Schema Information
# Schema version: 60
#
# Table name: categories
#
#  id       :integer(11)   not null, primary key
#  name     :string(255)   
#  position :integer(11)   default(0)
#

class Category < ActiveRecord::Base
  
  has_many :forums, :dependent => :destroy
  
  validates_presence_of     :name
  validates_uniqueness_of   :name, :case_sensitive => false
    
end
