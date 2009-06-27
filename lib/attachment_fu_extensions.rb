module AttachmentFuExtensions
    
  # include some standard attachment_fu stuff
  def self.included(klass)
    klass.send :attr_protected, :id, :parent_id, :user_id, :created_at, :updated_at
    klass.send :validates_as_attachment
    klass.send :validates_uniqueness_of, :filename
    klass.send :validates_presence_of, :user_id, :filename
    klass.send :validate, :disallow_uploading_files_that_would_be_served_instead_of_index_action
  end
  
  def disallow_uploading_files_that_would_be_served_instead_of_index_action
    errors.add(:filename) if filename && %w(index.htm index.html).include?(filename.downcase)
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
