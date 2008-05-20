class Avatar < ActiveRecord::Base

  belongs_to :user
  belongs_to :current_avatar_user, :foreign_key => "current_user_id", :class_name => "User"

  has_attachment :storage => :file_system, :max_size => 500.kilobytes, :content_type => :image
  include AttachmentFuExtensions
  
  def to_s
    filename
  end
end
