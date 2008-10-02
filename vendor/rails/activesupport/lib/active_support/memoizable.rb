module ActiveSupport
<<<<<<< HEAD:vendor/rails/activesupport/lib/active_support/memoizable.rb
  module Memoizable
    module Freezable
      def self.included(base)
        base.class_eval do
          unless base.method_defined?(:freeze_without_memoizable)
            alias_method_chain :freeze, :memoizable
          end
        end
      end

      def freeze_with_memoizable
        memoize_all unless frozen?
        freeze_without_memoizable
      end

      def memoize_all
        methods.each do |m|
          if m.to_s =~ /^_unmemoized_(.*)/
            if method(m).arity == 0
              __send__($1)
            else
              ivar = :"@_memoized_#{$1}"
              instance_variable_set(ivar, {})
            end
          end
        end
      end

      def unmemoize_all
        methods.each do |m|
          if m.to_s =~ /^_unmemoized_(.*)/
            ivar = :"@_memoized_#{$1}"
            instance_variable_get(ivar).clear if instance_variable_defined?(ivar)
          end
        end
      end
    end

=======
  module Memoizable #:nodoc:
>>>>>>> i18n:vendor/rails/activesupport/lib/active_support/memoizable.rb
    def memoize(*symbols)
      symbols.each do |symbol|
<<<<<<< HEAD:vendor/rails/activesupport/lib/active_support/memoizable.rb
        original_method = :"_unmemoized_#{symbol}"
        memoized_ivar = :"@_memoized_#{symbol.to_s.sub(/\?\Z/, '_query').sub(/!\Z/, '_bang')}"

        class_eval <<-EOS, __FILE__, __LINE__
          include Freezable

          raise "Already memoized #{symbol}" if method_defined?(:#{original_method})
          alias #{original_method} #{symbol}

          if instance_method(:#{symbol}).arity == 0
            def #{symbol}(reload = false)
              if reload || !defined?(#{memoized_ivar}) || #{memoized_ivar}.empty?
                #{memoized_ivar} = [#{original_method}.freeze]
=======
        original_method = "unmemoized_#{symbol}"
        memoized_ivar = "@#{symbol}"

        klass = respond_to?(:class_eval) ? self : self.metaclass
        raise "Already memoized #{symbol}" if klass.instance_methods.map(&:to_s).include?(original_method)

        klass.class_eval <<-EOS, __FILE__, __LINE__
          unless instance_methods.map(&:to_s).include?("freeze_without_memoizable")
            alias_method :freeze_without_memoizable, :freeze
            def freeze
              methods.each do |method|
                if m = method.to_s.match(/^unmemoized_(.*)/)
                  send(m[1])
                end
>>>>>>> i18n:vendor/rails/activesupport/lib/active_support/memoizable.rb
              end
<<<<<<< HEAD:vendor/rails/activesupport/lib/active_support/memoizable.rb
              #{memoized_ivar}[0]
=======
              freeze_without_memoizable
>>>>>>> i18n:vendor/rails/activesupport/lib/active_support/memoizable.rb
            end
<<<<<<< HEAD:vendor/rails/activesupport/lib/active_support/memoizable.rb
          else
            def #{symbol}(*args)
              #{memoized_ivar} ||= {} unless frozen?
              reload = args.pop if args.last == true || args.last == :reload
=======
          end
>>>>>>> i18n:vendor/rails/activesupport/lib/active_support/memoizable.rb

<<<<<<< HEAD:vendor/rails/activesupport/lib/active_support/memoizable.rb
              if defined?(#{memoized_ivar}) && #{memoized_ivar}
                if !reload && #{memoized_ivar}.has_key?(args)
                  #{memoized_ivar}[args]
                elsif #{memoized_ivar}
                  #{memoized_ivar}[args] = #{original_method}(*args).freeze
                end
              else
                #{original_method}(*args)
              end
=======
          alias_method :#{original_method}, :#{symbol}
          def #{symbol}(reload = false)
            if !reload && defined? #{memoized_ivar}
              #{memoized_ivar}
            else
              #{memoized_ivar} = #{original_method}.freeze
>>>>>>> i18n:vendor/rails/activesupport/lib/active_support/memoizable.rb
            end
          end
        EOS
      end
    end
  end
end
