module ActiveSupport
<<<<<<< HEAD:vendor/rails/activesupport/lib/active_support/string_inquirer.rb
  # Wrapping a string in this class gives you a prettier way to test
  # for equality. The value returned by <tt>Rails.env</tt> is wrapped
  # in a StringInquirer object so instead of calling this:
  #
  #   Rails.env == "production"
  #
  # you can call this:
  #
  #   Rails.env.production?
  #
=======
>>>>>>> i18n:vendor/rails/activesupport/lib/active_support/string_inquirer.rb
  class StringInquirer < String
    def method_missing(method_name, *arguments)
      if method_name.to_s.ends_with?("?")
        self == method_name.to_s[0..-2]
      else
        super
      end
    end
  end
end
