RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  require 'yaml'
  
  config.time_zone = 'UTC'
  config.i18n.default_locale = :en
  config.active_record.partial_updates = true
  config.frameworks -= [ :active_resource ]
    
  # support yaml and heroku config
  CONFIG = (YAML.load_file('config/config.yml')[RAILS_ENV] rescue {}).merge(ENV)
  
  # consider s3 enabled if the configuration options have been set
  CONFIG['s3_access_id'] && CONFIG['s3_secret_key'] && CONFIG['s3_bucket_name'] ? CONFIG['s3'] = true : CONFIG['s3'] = false
  
  config.action_controller.session = {
    :key => CONFIG['session_key'],
    :secret => CONFIG['session_secret']
  }
  
end

HoptoadNotifier.configure do |config|
  config.api_key = CONFIG['hoptoad_key']
end if CONFIG['hoptoad_key']
