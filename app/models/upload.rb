# == Schema Information
# Schema version: 56
#
# Table name: uploads
#
#  id           :integer(11)   not null, primary key
#  parent_id    :integer(11)   
#  content_type :string(255)   
#  filename     :string(255)   
#  thumbnail    :string(255)   
#  size         :integer(11)   
#  width        :integer(11)   
#  height       :integer(11)   
#  user_id      :integer(11)   
#  created_at   :datetime      
#  updated_at   :datetime      
#

class Upload < ActiveRecord::Base
  
  belongs_to :user
  
  has_attachment :storage => :file_system, :path_prefix => 'public/files', :max_size => 50.megabytes
  
  validates_as_attachment
  validates_uniqueness_of :filename
  validates_presence_of :user_id
  
  attr_protected :id, :parent_id, :user_id, :created_at, :updated_at 
  
  def full_filename(thumbnail = nil)
    file_system_path = (thumbnail ? thumbnail_class : self).attachment_options[:path_prefix].to_s
    File.join(RAILS_ROOT, file_system_path, thumbnail_name_for(thumbnail))
  end
      
end
