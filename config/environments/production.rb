config.cache_classes = true
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching = true
config.action_view.cache_template_loading = true

config.after_initialize do
  require 'application_controller' unless Object.const_defined?(:ApplicationController)
  LoggedExceptionsController.class_eval do
    session :session_key => '_eldorado_session_id'
    self.application_name = "El Dorado"
    include AuthenticationSystem
    before_filter :require_admin
  end
end
