# == Schema Information
# Schema version: 68
#
# Table name: avatars
#
#  id              :integer         not null, primary key
#  parent_id       :integer         
#  content_type    :string(255)     
#  filename        :string(255)     
#  thumbnail       :string(255)     
#  size            :integer         
#  width           :integer         
#  height          :integer         
#  user_id         :integer         
#  current_user_id :integer         
#  created_at      :datetime        
#  updated_at      :datetime        
#

class Avatar < ActiveRecord::Base

  belongs_to :user
  belongs_to :current_avatar_user, :foreign_key => "current_user_id", :class_name => "User"

  has_attachment :content_type => :image, :storage => :file_system, :max_size => 500.kilobytes
  include AttachmentFuExtensions
    
  def to_s
    filename.to_s
  end
  
end
