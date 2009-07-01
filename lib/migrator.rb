class Migrator
  
  def self.attachment_fu_to_paperclip
    %w(Avatar Upload Header Theme).each do |klass|
      klass.constantize.record_timestamps = false
      klass.constantize.find_each do |instance|
        instance.update_attribute(:attachment_file_name, instance.filename)
        instance.update_attribute(:attachment_content_type, instance.content_type)
        instance.update_attribute(:attachment_file_size, instance.size)
      end
    end
  end
  
end
