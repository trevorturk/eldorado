class Header < ActiveRecord::Base
    
  include PaperclipSupport
  
  attr_accessible :description
  
  belongs_to :user
    
  if CONFIG['s3']
    has_attached_file :attachment, :storage => :s3, :path => "headers/:filename", :bucket => CONFIG['s3_bucket_name'],
                      :s3_host_alias => CONFIG['s3_host_alias'], :url => CONFIG['s3_host_alias'] ? ':s3_alias_url' : nil,
                      :s3_credentials => { :access_key_id => CONFIG['s3_access_id'], :secret_access_key => CONFIG['s3_secret_key'] },
                      :s3_headers => { 'Cache-Control' => 'max-age=315576000', 'Expires' => 10.years.from_now.httpdate }
  else
    has_attached_file :attachment, :storage => :filesystem, :url => "/headers/:filename"
  end
  
  validates_attachment_size :attachment, :less_than => 500.kilobytes
  validates_attachment_content_type :attachment, :content_type => /image/
  
  def self.random
    ids = connection.select_all("SELECT id FROM headers where votes >= 0")
    find(ids[rand(ids.length)]["id"].to_i) unless ids.blank?
  end
    
  def vote_up
    self.votes = self.votes + 1
    self.save(false)
  end

  def vote_down
    self.votes = self.votes - 1
    self.save(false)
  end
  
end
