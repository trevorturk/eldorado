class Object
  # Get object's meta (ghost, eigenclass, singleton) class
  def metaclass
    class << self
      self
    end
  end
<<<<<<< HEAD:vendor/rails/activesupport/lib/active_support/core_ext/object/metaclass.rb

  # If class_eval is called on an object, add those methods to its metaclass
  def class_eval(*args, &block)
    metaclass.class_eval(*args, &block)
  end
=======
>>>>>>> i18n:vendor/rails/activesupport/lib/active_support/core_ext/object/metaclass.rb
end
