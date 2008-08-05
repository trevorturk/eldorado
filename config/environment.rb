# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|  
  require 'open-uri'
  require 'yaml'
  
  config.time_zone = 'UTC'
  config.active_record.partial_updates = true
  
  # The session_key and secret (for verifying session data integrity) are set in config/database.yml
  db = YAML.load_file('config/database.yml')
  config.action_controller.session = {
    :session_key => db[RAILS_ENV]['session_key'],
    :secret      => db[RAILS_ENV]['secret']
  }
end
