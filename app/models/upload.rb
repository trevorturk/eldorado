class Upload < ActiveRecord::Base
  
  belongs_to :user, :counter_cache => true
  
  has_attachment :storage => :file_system, :path_prefix => 'public/files', :max_size => 15.megabytes
  
  validates_as_attachment
  validates_uniqueness_of :filename
  validates_presence_of :user_id
  
  def full_filename(thumbnail = nil)
    file_system_path = (thumbnail ? thumbnail_class : self).attachment_options[:path_prefix].to_s
    File.join(RAILS_ROOT, file_system_path, thumbnail_name_for(thumbnail))
  end
  
  def can_edit_upload?(user)
    user.admin? || (user.id == user_id)
  end
  
end
