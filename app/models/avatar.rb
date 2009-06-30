class Avatar < ActiveRecord::Base
  
  include PaperclipSupport
  
  belongs_to :user
  belongs_to :current_avatar_user, :foreign_key => 'current_user_id', :class_name => 'User'
  
  has_attached_file :attachment, :url => "/avatars/:filename", :storage => :filesystem
  
  validates_attachment_size :attachment, :less_than => 500.kilobytes
  validates_attachment_content_type :attachment, :content_type => /image/
  
  after_destroy :nullify_current_avatar_user
  
  def nullify_current_avatar_user
    self.current_avatar_user.update_attribute(:avatar, nil) rescue nil
  end
    
end
