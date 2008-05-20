# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION   = '2.0.2' unless defined? RAILS_GEM_VERSION
APPLICATION_VERSION = '0.9.3 (beta)'

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
    
  # The session_key and secret (for verifying session data integrity) can be set in config/database.yml
  require 'yaml'
  db = YAML.load_file('config/database.yml')
  config.action_controller.session = {
    :session_key => db[RAILS_ENV]['session_key'],
    :secret      => db[RAILS_ENV]['secret']
  }
  
  # UTC for Active Record and Time.now
  config.time_zone = 'UTC'
  ENV['TZ'] = 'UTC'
  
  config.gem 'will_paginate'
  
end
