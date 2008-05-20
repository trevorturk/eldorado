class Theme < ActiveRecord::Base
  
  belongs_to :user
  
  has_attachment :storage => :file_system, :max_size => 50.kilobytes
  include AttachmentFuExtensions
    
  def to_s
    filename
  end
end
