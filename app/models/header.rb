class Header < ActiveRecord::Base
  
  has_attachment :content_type => :image, :storage => :file_system, :max_size => 50.kilobytes
  validates_as_attachment
  validates_uniqueness_of :filename

  def full_filename(thumbnail = nil)
    file_system_path = (thumbnail ? thumbnail_class : self).attachment_options[:path_prefix].to_s
    File.join(RAILS_ROOT, file_system_path, thumbnail_name_for(thumbnail))
  end

end
