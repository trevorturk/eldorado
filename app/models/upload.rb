class Upload < ActiveRecord::Base
  
  attr_protected :id, :parent_id, :content_type, :filename, :thumbnail, :size, :width, :height, :user_id, :created_at, :updated_at
  
  belongs_to :user
  
  has_attachment :storage => :file_system, :partition => false, :path_prefix => 'public/files', :max_size => 100.megabytes
  include AttachmentFuExtensions
  
  def is_mp3?
    return true if %w(audio/mpeg audio/mpg).include?(content_type)
  end
  
  def to_s
    filename
  end
  
end
