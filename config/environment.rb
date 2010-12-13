RAILS_GEM_VERSION = '2.3.9' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  require 'yaml'
  CONFIG = (YAML.load_file('config/config.yml')[RAILS_ENV] rescue {}).merge(ENV)
  CONFIG['s3'] = true if CONFIG['s3_access_id'] && CONFIG['s3_secret_key'] && CONFIG['s3_bucket_name']
  config.time_zone = 'UTC'
  config.i18n.default_locale = :en
  config.active_record.partial_updates = true
  config.frameworks -= [:active_resource]
  config.action_controller.session = {:key => CONFIG['session_key'], :secret => CONFIG['session_secret']}
  config.gem "paperclip", :version => "2.3.0"
  config.gem "right_aws", :version => "1.9.0"
  config.gem "right_http_connection", :version => "1.2.4"
  config.gem "searchlogic", :version => "2.3.9"
  config.gem "will_paginate", :version => "2.3.15"
  config.gem "hoptoad_notifier", :version => "2.2.2" if CONFIG['hoptoad_key']
end
