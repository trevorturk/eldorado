module ActionView
  # There's also a convenience method for rendering sub templates within the current controller that depends on a
  # single object (we call this kind of sub templates for partials). It relies on the fact that partials should
  # follow the naming convention of being prefixed with an underscore -- as to separate them from regular
  # templates that could be rendered on their own.
  #
  # In a template for Advertiser#account:
  #
  #  <%= render :partial => "account" %>
  #
  # This would render "advertiser/_account.erb" and pass the instance variable @account in as a local variable
  # +account+ to the template for display.
  #
  # In another template for Advertiser#buy, we could have:
  #
  #   <%= render :partial => "account", :locals => { :account => @buyer } %>
  #
  #   <% for ad in @advertisements %>
  #     <%= render :partial => "ad", :locals => { :ad => ad } %>
  #   <% end %>
  #
  # This would first render "advertiser/_account.erb" with @buyer passed in as the local variable +account+, then
  # render "advertiser/_ad.erb" and pass the local variable +ad+ to the template for display.
  #
  # == Rendering a collection of partials
  #
  # The example of partial use describes a familiar pattern where a template needs to iterate over an array and
  # render a sub template for each of the elements. This pattern has been implemented as a single method that
  # accepts an array and renders a partial by the same name as the elements contained within. So the three-lined
  # example in "Using partials" can be rewritten with a single line:
  #
  #   <%= render :partial => "ad", :collection => @advertisements %>
  #
  # This will render "advertiser/_ad.erb" and pass the local variable +ad+ to the template for display. An
  # iteration counter will automatically be made available to the template with a name of the form
  # +partial_name_counter+. In the case of the example above, the template would be fed +ad_counter+.
  #
  # NOTE: Due to backwards compatibility concerns, the collection can't be one of hashes. Normally you'd also
  # just keep domain objects, like Active Records, in there.
  #
  # == Rendering shared partials
  #
  # Two controllers can share a set of partials and render them like this:
  #
  #   <%= render :partial => "advertisement/ad", :locals => { :ad => @advertisement } %>
  #
  # This will render the partial "advertisement/_ad.erb" regardless of which controller this is being called from.
  #
  # == Rendering partials with layouts
  #
  # Partials can have their own layouts applied to them. These layouts are different than the ones that are
  # specified globally for the entire action, but they work in a similar fashion. Imagine a list with two types
  # of users:
  #
  #   <%# app/views/users/index.html.erb &>
  #   Here's the administrator:
  #   <%= render :partial => "user", :layout => "administrator", :locals => { :user => administrator } %>
  #
  #   Here's the editor:
  #   <%= render :partial => "user", :layout => "editor", :locals => { :user => editor } %>
  #
  #   <%# app/views/users/_user.html.erb &>
  #   Name: <%= user.name %>
  #
  #   <%# app/views/users/_administrator.html.erb &>
  #   <div id="administrator">
  #     Budget: $<%= user.budget %>
  #     <%= yield %>
  #   </div>
  #
  #   <%# app/views/users/_editor.html.erb &>
  #   <div id="editor">
  #     Deadline: <%= user.deadline %>
  #     <%= yield %>
  #   </div>
  #
  # ...this will return:
  #
  #   Here's the administrator:
  #   <div id="administrator">
  #     Budget: $<%= user.budget %>
  #     Name: <%= user.name %>
  #   </div>
  #
  #   Here's the editor:
  #   <div id="editor">
  #     Deadline: <%= user.deadline %>
  #     Name: <%= user.name %>
  #   </div>
  #
  # You can also apply a layout to a block within any template:
  #
  #   <%# app/views/users/_chief.html.erb &>
  #   <% render(:layout => "administrator", :locals => { :user => chief }) do %>
  #     Title: <%= chief.title %>
  #   <% end %>
  #
  # ...this will return:
  #
  #   <div id="administrator">
  #     Budget: $<%= user.budget %>
  #     Title: <%= chief.name %>
  #   </div>
  #
  # As you can see, the <tt>:locals</tt> hash is shared between both the partial and its layout.
  #
  # If you pass arguments to "yield" then this will be passed to the block. One way to use this is to pass
  # an array to layout and treat it as an enumerable.
  #
  #   <%# app/views/users/_user.html.erb &>
  #   <div class="user">
  #     Budget: $<%= user.budget %>
  #     <%= yield user %>
  #   </div>
  #
  #   <%# app/views/users/index.html.erb &>
  #   <% render :layout => @users do |user| %>
  #     Title: <%= user.title %>
  #   <% end %>
  #
  # This will render the layout for each user and yield to the block, passing the user, each time.
  #
  # You can also yield multiple times in one layout and use block arguments to differentiate the sections.
  #
  #   <%# app/views/users/_user.html.erb &>
  #   <div class="user">
  #     <%= yield user, :header %>
  #     Budget: $<%= user.budget %>
  #     <%= yield user, :footer %>
  #   </div>
  #
  #   <%# app/views/users/index.html.erb &>
  #   <% render :layout => @users do |user, section| %>
  #     <%- case section when :header -%>
  #       Title: <%= user.title %>
  #     <%- when :footer -%>
  #       Deadline: <%= user.deadline %>
  #     <%- end -%>
  #   <% end %>
  module Partials
    extend ActiveSupport::Memoizable

    private
<<<<<<< HEAD:vendor/rails/actionpack/lib/action_view/partials.rb
      def render_partial(options = {}) #:nodoc:
        local_assigns = options[:locals] || {}
=======
      def render_partial(partial_path, object_assigns = nil, local_assigns = {}) #:nodoc:
        local_assigns ||= {}
>>>>>>> i18n:vendor/rails/actionpack/lib/action_view/partials.rb

<<<<<<< HEAD:vendor/rails/actionpack/lib/action_view/partials.rb
        case partial_path = options[:partial]
=======
        case partial_path
>>>>>>> i18n:vendor/rails/actionpack/lib/action_view/partials.rb
        when String, Symbol, NilClass
<<<<<<< HEAD:vendor/rails/actionpack/lib/action_view/partials.rb
          if options.has_key?(:collection)
            render_partial_collection(options)
          else
            _pick_partial_template(partial_path).render_partial(self, options[:object], local_assigns)
          end
=======
          pick_template(find_partial_path(partial_path)).render_partial(self, object_assigns, local_assigns)
>>>>>>> i18n:vendor/rails/actionpack/lib/action_view/partials.rb
        when ActionView::Helpers::FormBuilder
          builder_partial_path = partial_path.class.to_s.demodulize.underscore.sub(/_builder$/, '')
          local_assigns.merge!(builder_partial_path.to_sym => partial_path)
          render_partial(:partial => builder_partial_path, :object => options[:object], :locals => local_assigns)
        when Array, ActiveRecord::Associations::AssociationCollection, ActiveRecord::NamedScope::Scope
          render_partial_collection(options.except(:partial).merge(:collection => partial_path))
        else
          object = partial_path
          render_partial(
            :partial => ActionController::RecordIdentifier.partial_path(object, controller.class.controller_path),
            :object => object,
            :locals => local_assigns
          )
        end
      end

<<<<<<< HEAD:vendor/rails/actionpack/lib/action_view/partials.rb
      def render_partial_collection(options = {}) #:nodoc:
        return nil if options[:collection].blank?
=======
      def render_partial_collection(partial_path, collection, partial_spacer_template = nil, local_assigns = {}, as = nil) #:nodoc:
        return " " if collection.empty?
>>>>>>> i18n:vendor/rails/actionpack/lib/action_view/partials.rb

<<<<<<< HEAD:vendor/rails/actionpack/lib/action_view/partials.rb
        partial = options[:partial]
        spacer = options[:spacer_template] ? render(:partial => options[:spacer_template]) : ''
        local_assigns = options[:locals] ? options[:locals].clone : {}
        as = options[:as]
=======
        local_assigns = local_assigns ? local_assigns.clone : {}
        spacer = partial_spacer_template ? render(:partial => partial_spacer_template) : ''
        _paths = {}
        _templates = {}
>>>>>>> i18n:vendor/rails/actionpack/lib/action_view/partials.rb

        index = 0
<<<<<<< HEAD:vendor/rails/actionpack/lib/action_view/partials.rb
        options[:collection].map do |object|
          _partial_path ||= partial ||
            ActionController::RecordIdentifier.partial_path(object, controller.class.controller_path)
          template = _pick_partial_template(_partial_path)
=======
        collection.map do |object|
          _partial_path ||= partial_path || ActionController::RecordIdentifier.partial_path(object, controller.class.controller_path)
          path = _paths[_partial_path] ||= find_partial_path(_partial_path)
          template = _templates[path] ||= pick_template(path)
>>>>>>> i18n:vendor/rails/actionpack/lib/action_view/partials.rb
          local_assigns[template.counter_name] = index
          result = template.render_partial(self, object, local_assigns, as)
          index += 1
          result
        end.join(spacer)
      end

<<<<<<< HEAD:vendor/rails/actionpack/lib/action_view/partials.rb
      def _pick_partial_template(partial_path) #:nodoc:
=======
      def find_partial_path(partial_path)
>>>>>>> i18n:vendor/rails/actionpack/lib/action_view/partials.rb
        if partial_path.include?('/')
<<<<<<< HEAD:vendor/rails/actionpack/lib/action_view/partials.rb
          path = File.join(File.dirname(partial_path), "_#{File.basename(partial_path)}")
        elsif controller
          path = "#{controller.class.controller_path}/_#{partial_path}"
=======
          "#{File.dirname(partial_path)}/_#{File.basename(partial_path)}"
        elsif respond_to?(:controller)
          "#{controller.class.controller_path}/_#{partial_path}"
>>>>>>> i18n:vendor/rails/actionpack/lib/action_view/partials.rb
        else
<<<<<<< HEAD:vendor/rails/actionpack/lib/action_view/partials.rb
          path = "_#{partial_path}"
=======
          "_#{partial_path}"
>>>>>>> i18n:vendor/rails/actionpack/lib/action_view/partials.rb
        end
<<<<<<< HEAD:vendor/rails/actionpack/lib/action_view/partials.rb

        _pick_template(path)
=======
>>>>>>> i18n:vendor/rails/actionpack/lib/action_view/partials.rb
      end
      memoize :_pick_partial_template
  end
end
