class Upload < ActiveRecord::Base
  
  include PaperclipSupport
  
  belongs_to :user
  
  if CONFIG['s3']
    has_attached_file :attachment, :storage => :s3, :path => "files/:filename", :bucket => CONFIG['s3_bucket_name'],
                      :s3_host_alias => CONFIG['s3_host_alias'], :url => CONFIG['s3_host_alias'] ? ':s3_alias_url' : nil,
                      :s3_credentials => { :access_key_id => CONFIG['s3_access_id'], :secret_access_key => CONFIG['s3_secret_key'] },
                      :s3_headers => { 'Cache-Control' => 'max-age=315576000', 'Expires' => 10.years.from_now.httpdate }
  else
    has_attached_file :attachment, :storage => :filesystem, :url => "/files/:filename"
  end
  
  validates_attachment_size :attachment, :less_than => 100.megabytes
  
  def is_mp3?
    %w(audio/mpeg audio/mpg).include?(attachment_content_type) ? true : false
  end
  
  private
  
  def attachment_url_provided?
    !self.attachment_url.blank?
  end
  
  def download_remote_file
    self.attachment = do_download_remote_file
    self.attachment_remote_url = attachment_url
  end
  
  def do_download_remote_file
    io = open(URI.parse(attachment_url))
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end
  
end
