class Theme < ActiveRecord::Base
  
  include PaperclipSupport
  
  belongs_to :user
  
  if CONFIG['s3']
    has_attached_file :attachment, :storage => :s3, :path => "themes/:filename", :bucket => CONFIG['s3_bucket_name'],
                      :s3_host_alias => CONFIG['s3_host_alias'], :url => CONFIG['s3_host_alias'] ? ':s3_alias_url' : nil,
                      :s3_credentials => { :access_key_id => CONFIG['s3_access_id'], :secret_access_key => CONFIG['s3_secret_key'] },
                      :s3_headers => { 'Cache-Control' => 'max-age=315576000', 'Expires' => 10.years.from_now.httpdate }
  else
    has_attached_file :attachment, :storage => :filesystem, :url => "/themes/:filename"
  end
  
  validates_attachment_size :attachment, :less_than => 50.kilobytes
  validates_attachment_content_type :attachment, :content_type => /css/
  
  after_destroy :deselect
  
  def select
    Setting.first.update_attribute(:theme, self.attachment.url)
  end
  
  def deselect
    Setting.first.update_attribute(:theme, nil)
  end
  
end
