require 'set'

module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:
    module Hash #:nodoc:
      # Return a hash that includes everything but the given keys. This is useful for
      # limiting a set of parameters to everything but a few known toggles:
      #
      #   @person.update_attributes(params[:person].except(:admin))
      module Except
        # Returns a new hash without the given keys.
        def except(*keys)
<<<<<<< HEAD:vendor/rails/activesupport/lib/active_support/core_ext/hash/except.rb
          dup.except!(*keys)
=======
          clone.except!(*keys)
>>>>>>> i18n:vendor/rails/activesupport/lib/active_support/core_ext/hash/except.rb
        end

        # Replaces the hash without the given keys.
        def except!(*keys)
          keys.map! { |key| convert_key(key) } if respond_to?(:convert_key)
          keys.each { |key| delete(key) }
          self
        end
      end
    end
  end
end
