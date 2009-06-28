class Theme < ActiveRecord::Base
  
  include PaperclipSupport
  
  belongs_to :user
  
  has_attached_file :attachment, :url => "/themes/:filename", :storage => :filesystem
  
  validates_attachment_size :attachment, :less_than => 50.kilobytes
  
  validates_attachment_content_type :attachment, :content_type => ['text/css']
  
  after_destroy :deselect
  
  def select
    Setting.first.update_attribute(:theme, self.attachment_file_name)
  end
  
  def deselect
    Setting.first.update_attribute(:theme, nil)
  end
  
end
