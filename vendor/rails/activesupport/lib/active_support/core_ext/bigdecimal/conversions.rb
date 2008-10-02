require 'yaml'

module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:
    module BigDecimal #:nodoc:
      module Conversions
        DEFAULT_STRING_FORMAT = 'F'.freeze
        YAML_TAG = 'tag:yaml.org,2002:float'.freeze
        YAML_MAPPING = { 'Infinity' => '.Inf', '-Infinity' => '-.Inf', 'NaN' => '.NaN' }

        def self.included(base) #:nodoc:
          base.class_eval do
            alias_method :_original_to_s, :to_s
            alias_method :to_s, :to_formatted_s

            yaml_as YAML_TAG
          end
        end

        def to_formatted_s(format = DEFAULT_STRING_FORMAT)
          _original_to_s(format)
        end
<<<<<<< HEAD:vendor/rails/activesupport/lib/active_support/core_ext/bigdecimal/conversions.rb

        # This emits the number without any scientific notation.
        # This is better than self.to_f.to_s since it doesn't lose precision.
        #
        # Note that reconstituting YAML floats to native floats may lose precision.
        def to_yaml(opts = {})
          YAML.quick_emit(nil, opts) do |out|
            string = to_s
            out.scalar(YAML_TAG, YAML_MAPPING[string] || string, :plain)
=======
        
        yaml_as "tag:yaml.org,2002:float"
        def to_yaml( opts = {} )
          YAML::quick_emit( nil, opts ) do |out|
            # This emits the number without any scientific notation.
            # I prefer it to using self.to_f.to_s, which would lose precision.
            #
            # Note that YAML allows that when reconstituting floats
            # to native types, some precision may get lost.
            # There is no full precision real YAML tag that I am aware of.
            str = self.to_s
            if str == "Infinity"
              str = ".Inf"
            elsif str == "-Infinity"
              str = "-.Inf"
            elsif str == "NaN"
              str = ".NaN"
            end
            out.scalar( "tag:yaml.org,2002:float", str, :plain )
>>>>>>> i18n:vendor/rails/activesupport/lib/active_support/core_ext/bigdecimal/conversions.rb
          end
        end
      end
    end
  end
end
