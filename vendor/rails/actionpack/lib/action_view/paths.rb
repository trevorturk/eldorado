module ActionView #:nodoc:
  class PathSet < Array #:nodoc:
    def self.type_cast(obj)
      if obj.is_a?(String)
        if Base.warn_cache_misses && defined?(Rails) && Rails.initialized?
<<<<<<< HEAD:vendor/rails/actionpack/lib/action_view/paths.rb
          Base.logger.debug "[PERFORMANCE] Processing view path during a " +
=======
          Rails.logger.debug "[PERFORMANCE] Processing view path during a " +
>>>>>>> i18n:vendor/rails/actionpack/lib/action_view/paths.rb
            "request. This an expense disk operation that should be done at " +
            "boot. You can manually process this view path with " +
            "ActionView::Base.process_view_paths(#{obj.inspect}) and set it " +
            "as your view path"
        end
        Path.new(obj)
      else
        obj
      end
    end

<<<<<<< HEAD:vendor/rails/actionpack/lib/action_view/paths.rb
    def initialize(*args)
      super(*args).map! { |obj| self.class.type_cast(obj) }
    end

    def <<(obj)
      super(self.class.type_cast(obj))
    end

    def concat(array)
      super(array.map! { |obj| self.class.type_cast(obj) })
    end

    def insert(index, obj)
      super(index, self.class.type_cast(obj))
    end

    def push(*objs)
      super(*objs.map { |obj| self.class.type_cast(obj) })
    end

    def unshift(*objs)
      super(*objs.map { |obj| self.class.type_cast(obj) })
    end

=======
>>>>>>> i18n:vendor/rails/actionpack/lib/action_view/paths.rb
    class Path #:nodoc:
      def self.eager_load_templates!
        @eager_load_templates = true
      end

      def self.eager_load_templates?
        @eager_load_templates || false
      end

      attr_reader :path, :paths
<<<<<<< HEAD:vendor/rails/actionpack/lib/action_view/paths.rb
      delegate :to_s, :to_str, :hash, :inspect, :to => :path
=======
      delegate :to_s, :to_str, :inspect, :to => :path
>>>>>>> i18n:vendor/rails/actionpack/lib/action_view/paths.rb

<<<<<<< HEAD:vendor/rails/actionpack/lib/action_view/paths.rb
      def initialize(path, load = true)
=======
      def initialize(path)
>>>>>>> i18n:vendor/rails/actionpack/lib/action_view/paths.rb
        raise ArgumentError, "path already is a Path class" if path.is_a?(Path)
<<<<<<< HEAD:vendor/rails/actionpack/lib/action_view/paths.rb
=======

>>>>>>> i18n:vendor/rails/actionpack/lib/action_view/paths.rb
        @path = path.freeze
<<<<<<< HEAD:vendor/rails/actionpack/lib/action_view/paths.rb
        reload! if load
=======
        reload!
>>>>>>> i18n:vendor/rails/actionpack/lib/action_view/paths.rb
      end

      def ==(path)
        to_str == path.to_str
      end

<<<<<<< HEAD:vendor/rails/actionpack/lib/action_view/paths.rb
      def eql?(path)
        to_str == path.to_str
      end

=======
>>>>>>> i18n:vendor/rails/actionpack/lib/action_view/paths.rb
      def [](path)
<<<<<<< HEAD:vendor/rails/actionpack/lib/action_view/paths.rb
        raise "Unloaded view path! #{@path}" unless @loaded
=======
>>>>>>> i18n:vendor/rails/actionpack/lib/action_view/paths.rb
        @paths[path]
      end

<<<<<<< HEAD:vendor/rails/actionpack/lib/action_view/paths.rb
      def loaded?
        @loaded ? true : false
      end

      def load
        reload! unless loaded?
        self
      end

=======
>>>>>>> i18n:vendor/rails/actionpack/lib/action_view/paths.rb
      # Rebuild load path directory cache
      def reload!
        @paths = {}

        templates_in_path do |template|
          # Eager load memoized methods and freeze cached template
          template.freeze if self.class.eager_load_templates?

          @paths[template.path] = template
          @paths[template.path_without_extension] ||= template
        end

        @paths.freeze
<<<<<<< HEAD:vendor/rails/actionpack/lib/action_view/paths.rb
        @loaded = true
=======
>>>>>>> i18n:vendor/rails/actionpack/lib/action_view/paths.rb
      end

      private
        def templates_in_path
          (Dir.glob("#{@path}/**/*/**") | Dir.glob("#{@path}/**")).each do |file|
            unless File.directory?(file)
              yield Template.new(file.split("#{self}/").last, self)
            end
          end
        end
    end

<<<<<<< HEAD:vendor/rails/actionpack/lib/action_view/paths.rb
    def load
      each { |path| path.load }
=======
    def initialize(*args)
      super(*args).map! { |obj| self.class.type_cast(obj) }
>>>>>>> i18n:vendor/rails/actionpack/lib/action_view/paths.rb
    end

    def reload!
      each { |path| path.reload! }
    end

<<<<<<< HEAD:vendor/rails/actionpack/lib/action_view/paths.rb
=======
    def <<(obj)
      super(self.class.type_cast(obj))
    end

    def push(*objs)
      delete_paths!(objs)
      super(*objs.map { |obj| self.class.type_cast(obj) })
    end

    def unshift(*objs)
      delete_paths!(objs)
      super(*objs.map { |obj| self.class.type_cast(obj) })
    end

>>>>>>> i18n:vendor/rails/actionpack/lib/action_view/paths.rb
    def [](template_path)
      each do |path|
        if template = path[template_path]
          return template
        end
      end
      nil
    end
<<<<<<< HEAD:vendor/rails/actionpack/lib/action_view/paths.rb
=======

    private
      def delete_paths!(paths)
        paths.each { |p1| delete_if { |p2| p1.to_s == p2.to_s } }
      end
>>>>>>> i18n:vendor/rails/actionpack/lib/action_view/paths.rb
  end
end
