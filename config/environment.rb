# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  
  # Make Active Record use UTC-base instead of local time, and make Time.now return time in UTC
  config.active_record.default_timezone = :utc
  ENV['TZ'] = 'UTC'
  
  # The session_key and secret (for verifying session data integrity) can be set in config/database.yml
  require 'yaml'
  db = YAML.load_file('config/database.yml')
  config.action_controller.session = {
    :session_key => db[RAILS_ENV]['session_key'],
    :secret      => db[RAILS_ENV]['secret']
  }
  
end
