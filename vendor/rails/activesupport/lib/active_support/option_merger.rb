module ActiveSupport
  class OptionMerger #:nodoc:
    instance_methods.each do |method|
      undef_method(method) if method !~ /^(__|instance_eval|class|object_id)/
    end

    def initialize(context, options)
      @context, @options = context, options
    end

    private
      def method_missing(method, *arguments, &block)
        arguments << (arguments.last.respond_to?(:to_hash) ? @options.deep_merge(arguments.pop) : @options.dup)
<<<<<<< HEAD:vendor/rails/activesupport/lib/active_support/option_merger.rb
        @context.__send__(method, *arguments, &block)
=======
        @context.send!(method, *arguments, &block)
>>>>>>> i18n:vendor/rails/activesupport/lib/active_support/option_merger.rb
      end
  end
end
