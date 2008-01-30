module AttachmentFuExtensions

  def validate
    errors.add("filename", "is invalid") if %w(index.html index.htm).include?(filename.downcase)
  end
  
  def full_filename(thumbnail = nil)
    file_system_path = (thumbnail ? thumbnail_class : self).attachment_options[:path_prefix].to_s
    File.join(RAILS_ROOT, file_system_path, thumbnail_name_for(thumbnail))
  end

end