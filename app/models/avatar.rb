# == Schema Information
# Schema version: 62
#
# Table name: avatars
#
#  id              :integer(11)   not null, primary key
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

  has_attachment :content_type => :image, :storage => :file_system, :max_size => 500.kilobytes

  validates_as_attachment
  validates_uniqueness_of :filename
  validates_presence_of :user_id
  
  attr_protected :id, :parent_id, :user_id, :created_at, :updated_at 
  
  def full_filename(thumbnail = nil)
    file_system_path = (thumbnail ? thumbnail_class : self).attachment_options[:path_prefix].to_s
    File.join(RAILS_ROOT, file_system_path, thumbnail_name_for(thumbnail))
  end
  
end
