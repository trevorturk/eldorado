# via http://snippets.dzone.com/posts/show/3994

require 'open-uri'
require 'action_controller/vendor/html-scanner/html/document'

# Always write files gotten via a URL to tempfiles instead of StringIO
OpenURI::Buffer.module_eval {
  remove_const :StringMax
  const_set :StringMax, 0
}

class UrlUpload
  
  attr_reader :original_filename, :attachment_data
  
  def initialize(url)
    @attachment_data = open(url)
    @original_filename = determine_filename
  end

  def method_missing(symbol, *args)
    if self.attachment_data.respond_to? symbol
      self.attachment_data.send symbol, *args
    else
      super
    end
  end
  
  private
  
  def determine_filename
    path = self.attachment_data.base_uri.path
    filename = File.basename(path).downcase
    filename
  end
    
end