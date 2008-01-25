# == Schema Information
# Schema version: 68
#
# Table name: events
#
#  id          :integer         not null, primary key
#  title       :string(255)     
#  description :text            
#  date        :datetime        
#  private     :boolean         
#  reminder    :boolean         
#  user_id     :integer         
#  created_at  :datetime        
#  updated_at  :datetime        
#

class Event < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :title, :description, :date, :user_id
  
  attr_protected :id, :created_at, :updated_at 
  
  tz_time_attributes :date
  
  def to_s
    title.to_s
  end
  
end
