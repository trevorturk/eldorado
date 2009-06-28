class Upload < ActiveRecord::Base
  
  include PaperclipSupport
  
  belongs_to :user
  
  has_attached_file :attachment, :url => "/files/:filename", :storage => :filesystem
  validates_attachment_size :attachment, :less_than => 100.megabytes
  
  #   :storage => :s3,
  #   :s3_credentials => "#{Rails.root}/config/s3.yml",
  #   :s3_headers => {'Cache-Control' => 'max-age=315576000', 'Expires' => 10.years.from_now.httpdate}
  
  def is_mp3?
    return true if %w(audio/mpeg audio/mpg).include?(content_type)
  end
  
end
