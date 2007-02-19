class Newbie < ActiveRecord::Base
  
  validates_presence_of     :term
  validates_uniqueness_of   :term, :case_sensitive => false
  validates_length_of       :term, :maximum => 25
  
end
