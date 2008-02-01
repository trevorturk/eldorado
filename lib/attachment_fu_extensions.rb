module AttachmentFuExtensions
  
  def self.included(klass)
    klass.send :validates_as_attachment
    klass.send :validates_uniqueness_of, :filename
    klass.send :validates_presence_of, :user_id
    klass.send :attr_protected, :id, :parent_id, :user_id, :created_at, :updated_at
  end
  
  def validate
    errors.add("filename", "is invalid") if %w(index.html index.htm).include?(filename.downcase)
  end
  
  def full_filename(thumbnail = nil)
    file_system_path = (thumbnail ? thumbnail_class : self).attachment_options[:path_prefix].to_s
    File.join(RAILS_ROOT, file_system_path, thumbnail_name_for(thumbnail))
  end

end