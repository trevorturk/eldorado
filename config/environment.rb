RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|  
  require 'open-uri'
  require 'yaml'
    
  config.time_zone = 'UTC'
  config.active_record.partial_updates = true
  config.frameworks -= [ :active_resource ]
  # config.gem 'fiveruns_tuneup'
  
  # The session_key and secret (for verifying session data integrity) are set in config/database.yml
  CONFIG = YAML.load_file('config/database.yml')[RAILS_ENV]
  config.action_controller.session = {
    :key => CONFIG['session_key'],
    :secret => CONFIG['session_secret'] || CONFIG['secret'] # TODO deprecate 'secret'
  }
  
  MAILER = CONFIG['mailer'] || 'noreply@example.com' # TODO require in config
  DOMAIN = CONFIG['domain'] || 'example.com' # TODO require in config
  
end
