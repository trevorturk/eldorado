class Avatar < ActiveRecord::Base

  belongs_to :user
  belongs_to :current_avatar_user, :foreign_key => "current_user_id", :class_name => "User"

  has_attachment :content_type => :image, :storage => :file_system, :max_size => 20.kilobytes

  validates_as_attachment
  validates_uniqueness_of :filename
  validates_presence_of :user_id

  def full_filename(thumbnail = nil)
    file_system_path = (thumbnail ? thumbnail_class : self).attachment_options[:path_prefix].to_s
    File.join(RAILS_ROOT, file_system_path, thumbnail_name_for(thumbnail))
  end
  
  def last_updated_at
    updated_at
  end

end
  