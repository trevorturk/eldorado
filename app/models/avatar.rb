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
  validates_as_attachment
  
  validates_uniqueness_of :filename
  validates_presence_of :user_id
    
  attr_protected :id, :parent_id, :user_id, :created_at, :updated_at 
  
  def validate
    errors.add("filename", "is invalid") if %w(index.html index.htm).include?(filename.downcase)
  end
  
  def full_filename(thumbnail = nil)
    file_system_path = (thumbnail ? thumbnail_class : self).attachment_options[:path_prefix].to_s
    File.join(RAILS_ROOT, file_system_path, thumbnail_name_for(thumbnail))
  end
    
  def to_s
    filename.to_s
  end
  
end
