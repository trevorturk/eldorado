class Theme < ActiveRecord::Base
  
  attr_protected :id, :parent_id, :content_type, :filename, :thumbnail, :size, :width, :height, :user_id, :created_at, :updated_at
  
  belongs_to :user
  
  has_attachment :storage => :file_system, :partition => false, :max_size => 50.kilobytes
  include AttachmentFuExtensions
    
  def to_s
    filename
  end
  
end
