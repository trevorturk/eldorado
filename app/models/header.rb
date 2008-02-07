# == Schema Information
# Schema version: 69
#
# Table name: headers
#
#  id           :integer(11)     not null, primary key
#  parent_id    :integer(11)     
#  content_type :string(255)     
#  filename     :string(255)     
#  thumbnail    :string(255)     
#  size         :integer(11)     
#  width        :integer(11)     
#  height       :integer(11)     
#  description  :text            
#  user_id      :integer(11)     
#  created_at   :datetime        
#  updated_at   :datetime        
#  votes        :integer(11)     default(0)
#

class Header < ActiveRecord::Base
  
  belongs_to :user
  
  has_attachment :storage => :file_system, :path_prefix => 'public/headers', :max_size => 500.kilobytes
  include AttachmentFuExtensions
  
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
