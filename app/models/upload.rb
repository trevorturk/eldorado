# == Schema Information
# Schema version: 69
#
# Table name: uploads
#
#  id           :integer(11)     not null, primary key
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
#  private      :boolean(1)      
#

class Upload < ActiveRecord::Base
  
  belongs_to :user
  
  has_attachment :storage => :file_system, :path_prefix => 'public/files', :max_size => 100.megabytes
  include AttachmentFuExtensions
      
  def is_mp3?
    return true if %w(audio/mpeg audio/mpg).include?(content_type)
  end
    
  def to_s
    filename.to_s
  end

end
