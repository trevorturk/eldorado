class Avatar < ActiveRecord::Base
  
  include PaperclipSupport
  
  belongs_to :user
  belongs_to :current_avatar_user, :foreign_key => 'current_user_id', :class_name => 'User'
  
  if CONFIG['s3']
    has_attached_file :attachment, :storage => :s3, :path => "avatars/:filename", :bucket => CONFIG['s3_bucket_name'],
                      :s3_host_alias => CONFIG['s3_host_alias'], :url => CONFIG['s3_host_alias'] ? ':s3_alias_url' : nil,
                      :s3_credentials => { :access_key_id => CONFIG['s3_access_id'], :secret_access_key => CONFIG['s3_secret_key'] },
                      :s3_headers => { 'Cache-Control' => 'max-age=315576000', 'Expires' => 10.years.from_now.httpdate }
  else
    has_attached_file :attachment, :storage => :filesystem, :url => "/avatars/:filename"
  end
    
  validates_attachment_size :attachment, :less_than => 500.kilobytes
  validates_attachment_content_type :attachment, :content_type => /image/
  
  after_destroy :nullify_current_avatar_user
  
  def nullify_current_avatar_user
    self.current_avatar_user.update_attribute(:avatar, nil) rescue nil
  end
    
end
