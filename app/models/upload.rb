# == Schema Information
# Schema version: 68
#
# Table name: uploads
#
#  id           :integer         not null, primary key
#  parent_id    :integer         
#  content_type :string(255)     
#  filename     :string(255)     
#  thumbnail    :string(255)     
#  size         :integer         
#  width        :integer         
#  height       :integer         
#  user_id      :integer         
#  created_at   :datetime        
#  updated_at   :datetime        
#  private      :boolean         
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
