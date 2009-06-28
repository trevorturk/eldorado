class Upload < ActiveRecord::Base
  
  include PaperclipSupport
  
  belongs_to :user
  
  has_attached_file :attachment, :url => "/files/:filename", :storage => :filesystem
  
  validates_attachment_size :attachment, :less_than => 100.megabytes
  
  def is_mp3?
    %w(audio/mpeg audio/mpg).include?(attachment_content_type) ? true : false
  end
  
end
