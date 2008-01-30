# == Schema Information
# Schema version: 68
#
# Table name: headers
#
#  id           :integer         not null, primary key
#  parent_id    :integer         
#  content_type :string(255)     
#  filename     :string(255)     
#  thumbnail    :string(255)     
#  size         :integer         
#  width        :integer         
#  height       :integer         
#  description  :text            
#  user_id      :integer         
#  created_at   :datetime        
#  updated_at   :datetime        
#  votes        :integer         default(0)
#

class Header < ActiveRecord::Base
  
  belongs_to :user
  
  has_attachment :storage => :file_system, :path_prefix => 'public/headers', :max_size => 500.kilobytes
  include AttachmentFuExtensions
  
  validates_as_attachment
  validates_uniqueness_of :filename
  validates_presence_of :user_id
    
  attr_protected :id, :parent_id, :user_id, :created_at, :updated_at
  
  def self.random
    ids = connection.select_all("SELECT id FROM headers where votes >= 0")
    find(ids[rand(ids.length)]["id"].to_i) unless ids.blank?
  end
    
  def vote_up
    self.votes = self.votes + 1
    self.save!
  end

  def vote_down
    self.votes = self.votes - 1
    self.save!
  end
  
  def to_s
    filename.to_s
  end

end
