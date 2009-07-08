config.cache_classes = true
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching = true
config.action_view.cache_template_loading = true
config.action_mailer.raise_delivery_errors = true

config.after_initialize do
  require 'application_controller' unless Object.const_defined?(:ApplicationController)
  LoggedExceptionsController.class_eval do
    session :session_key => '_eldorado_session_id'
    self.application_name = "El Dorado"
    include AuthenticationSystem
    before_filter :require_admin
  end
end

if CONFIG['smtp_address']
  config.action_mailer.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :address => CONFIG['smtp_address'],
    :port => CONFIG['smtp_port'], 
    :domain => CONFIG['smtp_domain'],
    :user_name => CONFIG['smtp_user_name'],
    :password => CONFIG['smtp_password'],
    :authentication => CONFIG['smtp_authentication']
    :enable_starttls_auto => CONFIG['smtp_enable_starttls_auto']
  }
end
