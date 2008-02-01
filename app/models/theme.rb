# == Schema Information
# Schema version: 68
#
# Table name: themes
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
#

class Theme < ActiveRecord::Base
  
  belongs_to :user
  
  has_attachment :storage => :file_system, :path_prefix => 'public/themes', :max_size => 50.kilobytes
  include AttachmentFuExtensions
    
  def to_s
    filename.to_s
  end
    
end
