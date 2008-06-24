class Avatar < ActiveRecord::Base

  belongs_to :user
  belongs_to :current_avatar_user, :foreign_key => 'current_user_id', :class_name => 'User'

  has_attachment :storage => :file_system, :partition => false, :content_type => :image, :max_size => 500.kilobytes
  include AttachmentFuExtensions
  
  after_destroy :nullify_current_avatar_user
  
  def nullify_current_avatar_user
    self.current_avatar_user.update_attribute(:avatar, nil) rescue nil
  end
  
  def to_s
    filename
  end
end
