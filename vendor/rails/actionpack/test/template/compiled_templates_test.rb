require 'abstract_unit'
require 'controller/fake_models'

uses_mocha 'TestTemplateRecompilation' do
  class CompiledTemplatesTest < Test::Unit::TestCase
    def setup
<<<<<<< HEAD:vendor/rails/actionpack/test/template/compiled_templates_test.rb
=======
      @view = ActionView::Base.new(ActionController::Base.view_paths, {})
>>>>>>> i18n:vendor/rails/actionpack/test/template/compiled_templates_test.rb
      @compiled_templates = ActionView::Base::CompiledTemplates
      @compiled_templates.instance_methods.each do |m|
        @compiled_templates.send(:remove_method, m) if m =~ /^_run_/
      end
    end

    def test_template_gets_compiled
      assert_equal 0, @compiled_templates.instance_methods.size
<<<<<<< HEAD:vendor/rails/actionpack/test/template/compiled_templates_test.rb
      assert_equal "Hello world!", render("test/hello_world.erb")
=======
      assert_equal "Hello world!", @view.render("test/hello_world.erb")
>>>>>>> i18n:vendor/rails/actionpack/test/template/compiled_templates_test.rb
      assert_equal 1, @compiled_templates.instance_methods.size
    end

    def test_template_gets_recompiled_when_using_different_keys_in_local_assigns
      assert_equal 0, @compiled_templates.instance_methods.size
<<<<<<< HEAD:vendor/rails/actionpack/test/template/compiled_templates_test.rb
      assert_equal "Hello world!", render("test/hello_world.erb")
      assert_equal "Hello world!", render("test/hello_world.erb", {:foo => "bar"})
=======
      assert_equal "Hello world!", @view.render("test/hello_world.erb")
      assert_equal "Hello world!", @view.render("test/hello_world.erb", {:foo => "bar"})
>>>>>>> i18n:vendor/rails/actionpack/test/template/compiled_templates_test.rb
      assert_equal 2, @compiled_templates.instance_methods.size
    end

    def test_compiled_template_will_not_be_recompiled_when_rendered_with_identical_local_assigns
      assert_equal 0, @compiled_templates.instance_methods.size
<<<<<<< HEAD:vendor/rails/actionpack/test/template/compiled_templates_test.rb
      assert_equal "Hello world!", render("test/hello_world.erb")
=======
      assert_equal "Hello world!", @view.render("test/hello_world.erb")
>>>>>>> i18n:vendor/rails/actionpack/test/template/compiled_templates_test.rb
      ActionView::Template.any_instance.expects(:compile!).never
<<<<<<< HEAD:vendor/rails/actionpack/test/template/compiled_templates_test.rb
      assert_equal "Hello world!", render("test/hello_world.erb")
=======
      assert_equal "Hello world!", @view.render("test/hello_world.erb")
>>>>>>> i18n:vendor/rails/actionpack/test/template/compiled_templates_test.rb
    end

<<<<<<< HEAD:vendor/rails/actionpack/test/template/compiled_templates_test.rb
    def test_compiled_template_will_always_be_recompiled_when_eager_loaded_templates_is_off
      ActionView::PathSet::Path.expects(:eager_load_templates?).times(4).returns(false)
=======
    def test_compiled_template_will_always_be_recompiled_when_rendered_if_template_is_outside_cache
>>>>>>> i18n:vendor/rails/actionpack/test/template/compiled_templates_test.rb
      assert_equal 0, @compiled_templates.instance_methods.size
<<<<<<< HEAD:vendor/rails/actionpack/test/template/compiled_templates_test.rb
      assert_equal "Hello world!", render("#{FIXTURE_LOAD_PATH}/test/hello_world.erb")
=======
      assert_equal "Hello world!", @view.render("#{FIXTURE_LOAD_PATH}/test/hello_world.erb")
>>>>>>> i18n:vendor/rails/actionpack/test/template/compiled_templates_test.rb
      ActionView::Template.any_instance.expects(:compile!).times(3)
<<<<<<< HEAD:vendor/rails/actionpack/test/template/compiled_templates_test.rb
      3.times { assert_equal "Hello world!", render("#{FIXTURE_LOAD_PATH}/test/hello_world.erb") }
      assert_equal 1, @compiled_templates.instance_methods.size
=======
      3.times { assert_equal "Hello world!", @view.render("#{FIXTURE_LOAD_PATH}/test/hello_world.erb") }
>>>>>>> i18n:vendor/rails/actionpack/test/template/compiled_templates_test.rb
    end
<<<<<<< HEAD:vendor/rails/actionpack/test/template/compiled_templates_test.rb

    private
      def render(*args)
        ActionView::Base.new(ActionController::Base.view_paths, {}).render(*args)
      end
=======
>>>>>>> i18n:vendor/rails/actionpack/test/template/compiled_templates_test.rb
  end
end
