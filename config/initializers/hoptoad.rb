HoptoadNotifier.configure do |config|
  config.api_key = CONFIG['hoptoad_key']
  config.ignore_only = [] # catch all errors
end if CONFIG['hoptoad_key']