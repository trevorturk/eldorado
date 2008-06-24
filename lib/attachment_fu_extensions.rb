module AttachmentFuExtensions
    
  # include some standard attachment_fu stuff
  def self.included(klass)
    klass.send :validates_as_attachment
    klass.send :validates_uniqueness_of, :filename
    klass.send :validates_presence_of, :user_id
    klass.send :attr_protected, :id, :parent_id, :user_id, :created_at, :updated_at
  end
  
  # prevent users from uploading index files that would be served instead of the template/action
  def validate
    errors.add("filename", "is invalid") if filename? && %w(index.html index.htm).include?(filename.downcase)
  end
  
  # allow uploads via URL
  attr_reader :url
  def url=(uri)
    return nil if uri.blank?
    io = (open(URI.parse(uri)) rescue return nil)
    (class << io; self; end;).class_eval do
      define_method(:original_filename) { base_uri.path.split('/').last }
    end
    self.uploaded_data = io
  end
end
