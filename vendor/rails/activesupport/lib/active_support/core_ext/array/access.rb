module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:
    module Array #:nodoc:
      # Makes it easier to access parts of an array.
      module Access
        # Returns the tail of the array from +position+.
        #
        #   %w( a b c d ).from(0)  # => %w( a b c d )
        #   %w( a b c d ).from(2)  # => %w( c d )
        #   %w( a b c d ).from(10) # => nil
        #   %w().from(0)           # => nil
        def from(position)
          self[position..-1]
        end
        
        # Returns the beginning of the array up to +position+.
        #
        #   %w( a b c d ).to(0)  # => %w( a )
        #   %w( a b c d ).to(2)  # => %w( a b c )
        #   %w( a b c d ).to(10) # => %w( a b c d )
        #   %w().to(0)           # => %w()
        def to(position)
          self[0..position]
        end

<<<<<<< HEAD:vendor/rails/activesupport/lib/active_support/core_ext/array/access.rb
        # Equals to <tt>self[1]</tt>.
=======
        # Equal to self[1]
>>>>>>> i18n:vendor/rails/activesupport/lib/active_support/core_ext/array/access.rb
        def second
          self[1]
        end

<<<<<<< HEAD:vendor/rails/activesupport/lib/active_support/core_ext/array/access.rb
        # Equals to <tt>self[2]</tt>.
=======
        # Equal to self[2]
>>>>>>> i18n:vendor/rails/activesupport/lib/active_support/core_ext/array/access.rb
        def third
          self[2]
        end

<<<<<<< HEAD:vendor/rails/activesupport/lib/active_support/core_ext/array/access.rb
        # Equals to <tt>self[3]</tt>.
=======
        # Equal to self[3]
>>>>>>> i18n:vendor/rails/activesupport/lib/active_support/core_ext/array/access.rb
        def fourth
          self[3]
        end

<<<<<<< HEAD:vendor/rails/activesupport/lib/active_support/core_ext/array/access.rb
        # Equals to <tt>self[4]</tt>.
=======
        # Equal to self[4]
>>>>>>> i18n:vendor/rails/activesupport/lib/active_support/core_ext/array/access.rb
        def fifth
          self[4]
        end

<<<<<<< HEAD:vendor/rails/activesupport/lib/active_support/core_ext/array/access.rb
        # Equals to <tt>self[5]</tt>.
=======
        # Equal to self[5]
>>>>>>> i18n:vendor/rails/activesupport/lib/active_support/core_ext/array/access.rb
        def sixth
          self[5]
        end

<<<<<<< HEAD:vendor/rails/activesupport/lib/active_support/core_ext/array/access.rb
        # Equals to <tt>self[6]</tt>.
=======
        # Equal to self[6]
>>>>>>> i18n:vendor/rails/activesupport/lib/active_support/core_ext/array/access.rb
        def seventh
          self[6]
        end

<<<<<<< HEAD:vendor/rails/activesupport/lib/active_support/core_ext/array/access.rb
        # Equals to <tt>self[7]</tt>.
=======
        # Equal to self[7]
>>>>>>> i18n:vendor/rails/activesupport/lib/active_support/core_ext/array/access.rb
        def eighth
          self[7]
        end

<<<<<<< HEAD:vendor/rails/activesupport/lib/active_support/core_ext/array/access.rb
        # Equals to <tt>self[8]</tt>.
=======
        # Equal to self[8]
>>>>>>> i18n:vendor/rails/activesupport/lib/active_support/core_ext/array/access.rb
        def ninth
          self[8]
        end

<<<<<<< HEAD:vendor/rails/activesupport/lib/active_support/core_ext/array/access.rb
        # Equals to <tt>self[9]</tt>.
=======
        # Equal to self[9]
>>>>>>> i18n:vendor/rails/activesupport/lib/active_support/core_ext/array/access.rb
        def tenth
          self[9]
        end
      end
    end
  end
end
