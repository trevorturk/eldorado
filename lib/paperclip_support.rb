module PaperclipSupport
  def self.included(klass)
    klass.class_eval do
      require 'open-uri'
      
      attr_accessible :attachment, :attachment_url
      attr_accessor :attachment_url
      
      before_validation :download_remote_file, :if => :attachment_url_provided?
      
      validates_presence_of :user_id, :attachment_file_name
      validates_presence_of :attachment_remote_url, :if => :attachment_url_provided?, :message => 'is invalid or inaccessible'
      validates_uniqueness_of :attachment_file_name
      
      def to_s
        attachment_file_name
      end
      
      def to_param
        "#{id}-#{to_s.parameterize}"
      end
      
      private
      
      def attachment_url_provided?
        !self.attachment_url.blank?
      end
      
      def download_remote_file
        self.attachment = do_download_remote_file
        self.attachment_remote_url = attachment_url
      end
      
      def do_download_remote_file
        io = open(URI.parse(attachment_url))
        def io.original_filename; base_uri.path.split('/').last; end
        io.original_filename.blank? ? nil : io
      rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
      end
    end
  end
end
