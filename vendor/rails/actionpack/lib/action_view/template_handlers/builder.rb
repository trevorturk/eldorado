require 'builder'

module ActionView
  module TemplateHandlers
    class Builder < TemplateHandler
      include Compilable

      def compile(template)
<<<<<<< HEAD:vendor/rails/actionpack/lib/action_view/template_handlers/builder.rb
        "_set_controller_content_type(Mime::XML);" +
=======
        "set_controller_content_type(Mime::XML);" +
>>>>>>> i18n:vendor/rails/actionpack/lib/action_view/template_handlers/builder.rb
          "xml = ::Builder::XmlMarkup.new(:indent => 2);" +
          "self.output_buffer = xml.target!;" +
          template.source +
          ";xml.target!;"
      end
    end
  end
end
