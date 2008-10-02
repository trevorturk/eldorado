module ActiveSupport
  class ModelName < String
    attr_reader :singular, :plural, :cache_key, :partial_path

    def initialize(name)
      super
      @singular = underscore.tr('/', '_').freeze
      @plural = @singular.pluralize.freeze
      @cache_key = tableize.freeze
      @partial_path = "#{@cache_key}/#{demodulize.underscore}".freeze
    end
  end

<<<<<<< HEAD:vendor/rails/activesupport/lib/active_support/core_ext/module/model_naming.rb
  module CoreExtensions
=======
  module CoreExt
>>>>>>> i18n:vendor/rails/activesupport/lib/active_support/core_ext/module/model_naming.rb
    module Module
<<<<<<< HEAD:vendor/rails/activesupport/lib/active_support/core_ext/module/model_naming.rb
      # Returns an ActiveSupport::ModelName object for module. It can be
      # used to retrieve all kinds of naming-related information.
      def model_name
        @model_name ||= ModelName.new(name)
=======
      module ModelNaming
        def model_name
          @model_name ||= ModelName.new(name)
        end
>>>>>>> i18n:vendor/rails/activesupport/lib/active_support/core_ext/module/model_naming.rb
      end
    end
  end
end
