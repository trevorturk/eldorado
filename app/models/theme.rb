class Theme < ActiveRecord::Base
  
  belongs_to :user
  
  has_attachment :storage => :file_system, :partition => false, :max_size => 50.kilobytes
  include AttachmentFuExtensions
    
  def to_s
    filename
  end
end
