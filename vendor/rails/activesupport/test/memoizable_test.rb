require 'abstract_unit'

uses_mocha 'Memoizable' do
  class MemoizableTest < Test::Unit::TestCase
    class Person
      extend ActiveSupport::Memoizable

<<<<<<< HEAD:vendor/rails/activesupport/test/memoizable_test.rb
      attr_reader :name_calls, :age_calls
      def initialize
        @name_calls = 0
        @age_calls = 0
      end

=======
>>>>>>> i18n:vendor/rails/activesupport/test/memoizable_test.rb
      def name
<<<<<<< HEAD:vendor/rails/activesupport/test/memoizable_test.rb
        @name_calls += 1
        "Josh"
      end

      def name?
        true
=======
        fetch_name_from_floppy
>>>>>>> i18n:vendor/rails/activesupport/test/memoizable_test.rb
      end
<<<<<<< HEAD:vendor/rails/activesupport/test/memoizable_test.rb
      memoize :name?
=======
>>>>>>> i18n:vendor/rails/activesupport/test/memoizable_test.rb

<<<<<<< HEAD:vendor/rails/activesupport/test/memoizable_test.rb
      def update(name)
        "Joshua"
      end
      memoize :update
=======
      memoize :name
>>>>>>> i18n:vendor/rails/activesupport/test/memoizable_test.rb

      def age
<<<<<<< HEAD:vendor/rails/activesupport/test/memoizable_test.rb
        @age_calls += 1
=======
>>>>>>> i18n:vendor/rails/activesupport/test/memoizable_test.rb
        nil
      end

<<<<<<< HEAD:vendor/rails/activesupport/test/memoizable_test.rb
      memoize :name, :age
    end

    class Company
      attr_reader :name_calls
      def initialize
        @name_calls = 0
      end

      def name
        @name_calls += 1
        "37signals"
      end
    end

    module Rates
      extend ActiveSupport::Memoizable

      attr_reader :sales_tax_calls
      def sales_tax(price)
        @sales_tax_calls ||= 0
        @sales_tax_calls += 1
        price * 0.1025
      end
      memoize :sales_tax
    end

    class Calculator
      extend ActiveSupport::Memoizable
      include Rates

      attr_reader :fib_calls
      def initialize
        @fib_calls = 0
=======
      def counter
        @counter ||= 0
        @counter += 1
>>>>>>> i18n:vendor/rails/activesupport/test/memoizable_test.rb
      end

<<<<<<< HEAD:vendor/rails/activesupport/test/memoizable_test.rb
      def fib(n)
        @fib_calls += 1
=======
      memoize :age, :counter
>>>>>>> i18n:vendor/rails/activesupport/test/memoizable_test.rb

<<<<<<< HEAD:vendor/rails/activesupport/test/memoizable_test.rb
        if n == 0 || n == 1
          n
        else
          fib(n - 1) + fib(n - 2)
=======
      private
        def fetch_name_from_floppy
          "Josh"
>>>>>>> i18n:vendor/rails/activesupport/test/memoizable_test.rb
        end
<<<<<<< HEAD:vendor/rails/activesupport/test/memoizable_test.rb
      end
      memoize :fib

      def counter
        @count ||= 0
        @count += 1
      end
      memoize :counter
=======
>>>>>>> i18n:vendor/rails/activesupport/test/memoizable_test.rb
    end

    def setup
      @person = Person.new
<<<<<<< HEAD:vendor/rails/activesupport/test/memoizable_test.rb
      @calculator = Calculator.new
=======
>>>>>>> i18n:vendor/rails/activesupport/test/memoizable_test.rb
    end

    def test_memoization
      assert_equal "Josh", @person.name
<<<<<<< HEAD:vendor/rails/activesupport/test/memoizable_test.rb
      assert_equal 1, @person.name_calls

      3.times { assert_equal "Josh", @person.name }
      assert_equal 1, @person.name_calls
    end

    def test_memoization_with_punctuation
      assert_equal true, @person.name?
    end
=======
>>>>>>> i18n:vendor/rails/activesupport/test/memoizable_test.rb

<<<<<<< HEAD:vendor/rails/activesupport/test/memoizable_test.rb
    def test_memoization_with_nil_value
      assert_equal nil, @person.age
      assert_equal 1, @person.age_calls

      3.times { assert_equal nil, @person.age }
      assert_equal 1, @person.age_calls
    end

    def test_memorized_results_are_immutable
      assert_equal "Josh", @person.name
      assert_raise(ActiveSupport::FrozenObjectError) { @person.name.gsub!("Josh", "Gosh") }
=======
      @person.expects(:fetch_name_from_floppy).never
      2.times { assert_equal "Josh", @person.name }
>>>>>>> i18n:vendor/rails/activesupport/test/memoizable_test.rb
    end

    def test_reloadable
<<<<<<< HEAD:vendor/rails/activesupport/test/memoizable_test.rb
      counter = @calculator.counter
      assert_equal 1, @calculator.counter
      assert_equal 2, @calculator.counter(:reload)
      assert_equal 2, @calculator.counter
      assert_equal 3, @calculator.counter(true)
      assert_equal 3, @calculator.counter
    end

    def test_unmemoize_all
      assert_equal 1, @calculator.counter

      assert @calculator.instance_variable_get(:@_memoized_counter).any?
      @calculator.unmemoize_all
      assert @calculator.instance_variable_get(:@_memoized_counter).empty?

      assert_equal 2, @calculator.counter
    end

    def test_memoize_all
      @calculator.memoize_all
      assert @calculator.instance_variable_defined?(:@_memoized_counter)
=======
      counter = @person.counter
      assert_equal 1, @person.counter
      assert_equal 2, @person.counter(:reload)
>>>>>>> i18n:vendor/rails/activesupport/test/memoizable_test.rb
    end

<<<<<<< HEAD:vendor/rails/activesupport/test/memoizable_test.rb
    def test_memoization_cache_is_different_for_each_instance
      assert_equal 1, @calculator.counter
      assert_equal 2, @calculator.counter(:reload)
      assert_equal 1, Calculator.new.counter
    end
=======
    def test_memoized_methods_are_frozen
      assert_equal true, @person.name.frozen?
>>>>>>> i18n:vendor/rails/activesupport/test/memoizable_test.rb

<<<<<<< HEAD:vendor/rails/activesupport/test/memoizable_test.rb
    def test_memoized_is_not_affected_by_freeze
=======
>>>>>>> i18n:vendor/rails/activesupport/test/memoizable_test.rb
      @person.freeze
      assert_equal "Josh", @person.name
<<<<<<< HEAD:vendor/rails/activesupport/test/memoizable_test.rb
      assert_equal "Joshua", @person.update("Joshua")
=======
      assert_equal true, @person.name.frozen?
>>>>>>> i18n:vendor/rails/activesupport/test/memoizable_test.rb
    end

<<<<<<< HEAD:vendor/rails/activesupport/test/memoizable_test.rb
    def test_memoization_with_args
      assert_equal 55, @calculator.fib(10)
      assert_equal 11, @calculator.fib_calls
=======
    def test_memoization_frozen_with_nil_value
      @person.freeze
      assert_equal nil, @person.age
>>>>>>> i18n:vendor/rails/activesupport/test/memoizable_test.rb
    end

<<<<<<< HEAD:vendor/rails/activesupport/test/memoizable_test.rb
    def test_reloadable_with_args
      assert_equal 55, @calculator.fib(10)
      assert_equal 11, @calculator.fib_calls
      assert_equal 55, @calculator.fib(10, :reload)
      assert_equal 12, @calculator.fib_calls
      assert_equal 55, @calculator.fib(10, true)
      assert_equal 13, @calculator.fib_calls
=======
    def test_double_memoization
      assert_raise(RuntimeError) { Person.memoize :name }
>>>>>>> i18n:vendor/rails/activesupport/test/memoizable_test.rb
    end

<<<<<<< HEAD:vendor/rails/activesupport/test/memoizable_test.rb
    def test_object_memoization
      [Company.new, Company.new, Company.new].each do |company|
        company.extend ActiveSupport::Memoizable
        company.memoize :name

        assert_equal "37signals", company.name
        assert_equal 1, company.name_calls
        assert_equal "37signals", company.name
        assert_equal 1, company.name_calls
=======
    class Company
      def name
        lookup_name
>>>>>>> i18n:vendor/rails/activesupport/test/memoizable_test.rb
      end
<<<<<<< HEAD:vendor/rails/activesupport/test/memoizable_test.rb
    end
=======
>>>>>>> i18n:vendor/rails/activesupport/test/memoizable_test.rb

<<<<<<< HEAD:vendor/rails/activesupport/test/memoizable_test.rb
    def test_memoized_module_methods
      assert_equal 1.025, @calculator.sales_tax(10)
      assert_equal 1, @calculator.sales_tax_calls
      assert_equal 1.025, @calculator.sales_tax(10)
      assert_equal 1, @calculator.sales_tax_calls
      assert_equal 2.5625, @calculator.sales_tax(25)
      assert_equal 2, @calculator.sales_tax_calls
    end

    def test_object_memoized_module_methods
      company = Company.new
      company.extend(Rates)

      assert_equal 1.025, company.sales_tax(10)
      assert_equal 1, company.sales_tax_calls
      assert_equal 1.025, company.sales_tax(10)
      assert_equal 1, company.sales_tax_calls
      assert_equal 2.5625, company.sales_tax(25)
      assert_equal 2, company.sales_tax_calls
=======
      def lookup_name
        "37signals"
      end
>>>>>>> i18n:vendor/rails/activesupport/test/memoizable_test.rb
    end

<<<<<<< HEAD:vendor/rails/activesupport/test/memoizable_test.rb
    def test_double_memoization
      assert_raise(RuntimeError) { Person.memoize :name }
      person = Person.new
      person.extend ActiveSupport::Memoizable
      assert_raise(RuntimeError) { person.memoize :name }

=======
    def test_object_memoization
>>>>>>> i18n:vendor/rails/activesupport/test/memoizable_test.rb
      company = Company.new
      company.extend ActiveSupport::Memoizable
      company.memoize :name
<<<<<<< HEAD:vendor/rails/activesupport/test/memoizable_test.rb
      assert_raise(RuntimeError) { company.memoize :name }
=======

      assert_equal "37signals", company.name
      # Mocha doesn't play well with frozen objects
      company.metaclass.instance_eval { define_method(:lookup_name) { b00m } }
      assert_equal "37signals", company.name

      assert_equal true, company.name.frozen?
      company.freeze
      assert_equal true, company.name.frozen?
>>>>>>> i18n:vendor/rails/activesupport/test/memoizable_test.rb
    end
  end
end
