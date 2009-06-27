RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|  
  require 'open-uri'
  require 'yaml'
  
  config.time_zone = 'UTC'
  config.i18n.default_locale = :en
  config.active_record.partial_updates = true
  config.frameworks -= [ :active_resource ]
  
  config.gem 'mislav-will_paginate', :version => '2.3.11', :lib => 'will_paginate', :source => 'http://gems.github.com'
  config.gem 'thoughtbot-paperclip', :version => '2.2.9.2', :lib => 'paperclip', :source => 'http://gems.github.com'
  
  CONFIG = (YAML.load_file('config/config.yml')[RAILS_ENV] rescue {}).merge(ENV) # support yaml and heroku config
  
  config.action_controller.session = {
    :key => CONFIG['session_key'],
    :secret => CONFIG['session_secret']
  }
    
end
  