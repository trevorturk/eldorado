# == Schema Information
# Schema version: 76
#
# Table name: avatars
#
#  id              :integer(11)     not null, primary key
#  parent_id       :integer(11)     
#  content_type    :string(255)     
#  filename        :string(255)     
#  thumbnail       :string(255)     
#  size            :integer(11)     
#  width           :integer(11)     
#  height          :integer(11)     
#  user_id         :integer(11)     
#  current_user_id :integer(11)     
#  created_at      :datetime        
#  updated_at      :datetime        
#

class Avatar < ActiveRecord::Base

  belongs_to :user
  belongs_to :current_avatar_user, :foreign_key => "current_user_id", :class_name => "User"

  has_attachment :storage => :file_system, :max_size => 500.kilobytes, :content_type => :image
  include AttachmentFuExtensions
  
  def to_s
    filename
  end
end
