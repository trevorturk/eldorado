Dir[File.join(RAILS_ROOT, 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

CONFIG = YAML.load_file('config/config.yml')[RAILS_ENV] rescue {}
require 'hoptoad_notifier/tasks' if CONFIG['hoptoad_key']
