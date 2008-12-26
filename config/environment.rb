RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|  
  require 'open-uri'
  require 'yaml'
    
  config.time_zone = 'UTC'
  config.active_record.partial_updates = true
  # config.gem 'fiveruns_tuneup'
  
  # The session_key and secret (for verifying session data integrity) are set in config/database.yml
  db = YAML.load_file('config/database.yml')
  config.action_controller.session = {
    :session_key => db[RAILS_ENV]['session_key'],
    :secret      => db[RAILS_ENV]['secret']
  }
end

# setup smtp mailer
require 'tlsmail'
smtp = YAML.load_file('config/smtp.yml')
Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
ActionMailer::Base.default_url_options[:host] = smtp[RAILS_ENV]['domain']
ActionMailer::Base.smtp_settings = {
  :address => smtp[RAILS_ENV]['address'],
  :port => smtp[RAILS_ENV]['port'],
  :domain => smtp[RAILS_ENV]['domain'],
  :authentication => :plain,
  :user_name => smtp[RAILS_ENV]['user_name'],
  :password => smtp[RAILS_ENV]['password']
}

MAILER = smtp[RAILS_ENV]['mailer']