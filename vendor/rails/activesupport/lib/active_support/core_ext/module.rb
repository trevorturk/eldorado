require 'active_support/core_ext/module/inclusion'
require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/module/attr_internal'
require 'active_support/core_ext/module/attr_accessor_with_default'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/module/introspection'
require 'active_support/core_ext/module/loading'
require 'active_support/core_ext/module/aliasing'
require 'active_support/core_ext/module/model_naming'
<<<<<<< HEAD:vendor/rails/activesupport/lib/active_support/core_ext/module.rb
require 'active_support/core_ext/module/synchronization'

module ActiveSupport
  module CoreExtensions
    # Various extensions for the Ruby core Module class.
    module Module
      # Nothing here. Only defined for API documentation purposes.
    end
  end
end
=======
>>>>>>> i18n:vendor/rails/activesupport/lib/active_support/core_ext/module.rb

class Module
<<<<<<< HEAD:vendor/rails/activesupport/lib/active_support/core_ext/module.rb
  include ActiveSupport::CoreExtensions::Module
=======
  include ActiveSupport::CoreExt::Module::ModelNaming
>>>>>>> i18n:vendor/rails/activesupport/lib/active_support/core_ext/module.rb
end
