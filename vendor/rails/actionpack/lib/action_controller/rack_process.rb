require 'action_controller/cgi_ext'
require 'action_controller/session/cookie_store'

module ActionController #:nodoc:
  class RackRequest < AbstractRequest #:nodoc:
<<<<<<< HEAD:vendor/rails/actionpack/lib/action_controller/rack_process.rb
    attr_accessor :session_options
=======
    attr_accessor :env, :session_options
>>>>>>> i18n:vendor/rails/actionpack/lib/action_controller/rack_process.rb
    attr_reader :cgi

    class SessionFixationAttempt < StandardError #:nodoc:
    end

    DEFAULT_SESSION_OPTIONS = {
      :database_manager => CGI::Session::CookieStore, # store data in cookie
      :prefix           => "ruby_sess.",    # prefix session file names
      :session_path     => "/",             # available to all paths in app
      :session_key      => "_session_id",
<<<<<<< HEAD:vendor/rails/actionpack/lib/action_controller/rack_process.rb
      :cookie_only      => true,
      :session_http_only=> true
    }
=======
      :cookie_only      => true
    } unless const_defined?(:DEFAULT_SESSION_OPTIONS)
>>>>>>> i18n:vendor/rails/actionpack/lib/action_controller/rack_process.rb

    def initialize(env, session_options = DEFAULT_SESSION_OPTIONS)
      @session_options = session_options
      @env = env
      @cgi = CGIWrapper.new(self)
      super()
    end

    %w[ AUTH_TYPE GATEWAY_INTERFACE PATH_INFO
<<<<<<< HEAD:vendor/rails/actionpack/lib/action_controller/rack_process.rb
        PATH_TRANSLATED REMOTE_HOST
=======
        PATH_TRANSLATED QUERY_STRING REMOTE_HOST
>>>>>>> i18n:vendor/rails/actionpack/lib/action_controller/rack_process.rb
        REMOTE_IDENT REMOTE_USER SCRIPT_NAME
        SERVER_NAME SERVER_PROTOCOL

        HTTP_ACCEPT HTTP_ACCEPT_CHARSET HTTP_ACCEPT_ENCODING
<<<<<<< HEAD:vendor/rails/actionpack/lib/action_controller/rack_process.rb
        HTTP_ACCEPT_LANGUAGE HTTP_CACHE_CONTROL HTTP_FROM
=======
        HTTP_ACCEPT_LANGUAGE HTTP_CACHE_CONTROL HTTP_FROM HTTP_HOST
>>>>>>> i18n:vendor/rails/actionpack/lib/action_controller/rack_process.rb
        HTTP_NEGOTIATE HTTP_PRAGMA HTTP_REFERER HTTP_USER_AGENT ].each do |env|
      define_method(env.sub(/^HTTP_/n, '').downcase) do
        @env[env]
      end
    end

<<<<<<< HEAD:vendor/rails/actionpack/lib/action_controller/rack_process.rb
    def query_string
      qs = super
      if !qs.blank?
        qs
=======
    # The request body is an IO input stream. If the RAW_POST_DATA environment
    # variable is already set, wrap it in a StringIO.
    def body
      if raw_post = env['RAW_POST_DATA']
        StringIO.new(raw_post)
>>>>>>> i18n:vendor/rails/actionpack/lib/action_controller/rack_process.rb
      else
<<<<<<< HEAD:vendor/rails/actionpack/lib/action_controller/rack_process.rb
        @env['QUERY_STRING']
=======
        @env['rack.input']
>>>>>>> i18n:vendor/rails/actionpack/lib/action_controller/rack_process.rb
      end
    end

<<<<<<< HEAD:vendor/rails/actionpack/lib/action_controller/rack_process.rb
    def body_stream #:nodoc:
      @env['rack.input']
    end

=======
>>>>>>> i18n:vendor/rails/actionpack/lib/action_controller/rack_process.rb
    def key?(key)
      @env.key?(key)
    end

<<<<<<< HEAD:vendor/rails/actionpack/lib/action_controller/rack_process.rb
=======
    def query_parameters
      @query_parameters ||= self.class.parse_query_parameters(query_string)
    end

    def request_parameters
      @request_parameters ||= parse_formatted_request_parameters
    end

>>>>>>> i18n:vendor/rails/actionpack/lib/action_controller/rack_process.rb
    def cookies
      return {} unless @env["HTTP_COOKIE"]

      unless @env["rack.request.cookie_string"] == @env["HTTP_COOKIE"]
        @env["rack.request.cookie_string"] = @env["HTTP_COOKIE"]
        @env["rack.request.cookie_hash"] = CGI::Cookie::parse(@env["rack.request.cookie_string"])
      end

      @env["rack.request.cookie_hash"]
    end

<<<<<<< HEAD:vendor/rails/actionpack/lib/action_controller/rack_process.rb
=======
    def host_with_port_without_standard_port_handling
      if forwarded = @env["HTTP_X_FORWARDED_HOST"]
        forwarded.split(/,\s?/).last
      elsif http_host = @env['HTTP_HOST']
        http_host
      elsif server_name = @env['SERVER_NAME']
        server_name
      else
        "#{env['SERVER_ADDR']}:#{env['SERVER_PORT']}"
      end
    end

    def host
      host_with_port_without_standard_port_handling.sub(/:\d+$/, '')
    end

    def port
      if host_with_port_without_standard_port_handling =~ /:(\d+)$/
        $1.to_i
      else
        standard_port
      end
    end

    def remote_addr
      @env['REMOTE_ADDR']
    end

>>>>>>> i18n:vendor/rails/actionpack/lib/action_controller/rack_process.rb
    def server_port
      @env['SERVER_PORT'].to_i
    end

    def server_software
      @env['SERVER_SOFTWARE'].split("/").first
    end

    def session
      unless defined?(@session)
        if @session_options == false
          @session = Hash.new
        else
          stale_session_check! do
            if cookie_only? && query_parameters[session_options_with_string_keys['session_key']]
              raise SessionFixationAttempt
            end
            case value = session_options_with_string_keys['new_session']
              when true
                @session = new_session
              when false
                begin
                  @session = CGI::Session.new(@cgi, session_options_with_string_keys)
                # CGI::Session raises ArgumentError if 'new_session' == false
                # and no session cookie or query param is present.
                rescue ArgumentError
                  @session = Hash.new
                end
              when nil
                @session = CGI::Session.new(@cgi, session_options_with_string_keys)
              else
                raise ArgumentError, "Invalid new_session option: #{value}"
            end
            @session['__valid_session']
          end
        end
      end
      @session
    end

    def reset_session
      @session.delete if defined?(@session) && @session.is_a?(CGI::Session)
      @session = new_session
    end

    private
      # Delete an old session if it exists then create a new one.
      def new_session
        if @session_options == false
          Hash.new
        else
          CGI::Session.new(@cgi, session_options_with_string_keys.merge("new_session" => false)).delete rescue nil
          CGI::Session.new(@cgi, session_options_with_string_keys.merge("new_session" => true))
        end
      end

      def cookie_only?
        session_options_with_string_keys['cookie_only']
      end

      def stale_session_check!
        yield
      rescue ArgumentError => argument_error
        if argument_error.message =~ %r{undefined class/module ([\w:]*\w)}
          begin
            # Note that the regexp does not allow $1 to end with a ':'
            $1.constantize
          rescue LoadError, NameError => const_error
            raise ActionController::SessionRestoreError, <<-end_msg
Session contains objects whose class definition isn\'t available.
Remember to require the classes for all objects kept in the session.
(Original exception: #{const_error.message} [#{const_error.class}])
end_msg
          end

          retry
        else
          raise
        end
      end

      def session_options_with_string_keys
        @session_options_with_string_keys ||= DEFAULT_SESSION_OPTIONS.merge(@session_options).stringify_keys
      end
  end

  class RackResponse < AbstractResponse #:nodoc:
<<<<<<< HEAD:vendor/rails/actionpack/lib/action_controller/rack_process.rb
=======
    attr_accessor :status

>>>>>>> i18n:vendor/rails/actionpack/lib/action_controller/rack_process.rb
    def initialize(request)
<<<<<<< HEAD:vendor/rails/actionpack/lib/action_controller/rack_process.rb
      @cgi = request.cgi
=======
      @request = request
>>>>>>> i18n:vendor/rails/actionpack/lib/action_controller/rack_process.rb
      @writer = lambda { |x| @body << x }
      @block = nil
      super()
    end

<<<<<<< HEAD:vendor/rails/actionpack/lib/action_controller/rack_process.rb
    # Retrieve status from instance variable if has already been delete
    def status
      @status || super
    end

=======
>>>>>>> i18n:vendor/rails/actionpack/lib/action_controller/rack_process.rb
    def out(output = $stdout, &block)
<<<<<<< HEAD:vendor/rails/actionpack/lib/action_controller/rack_process.rb
      # Nasty hack because CGI sessions are closed after the normal
      # prepare! statement
      set_cookies!

=======
>>>>>>> i18n:vendor/rails/actionpack/lib/action_controller/rack_process.rb
      @block = block
<<<<<<< HEAD:vendor/rails/actionpack/lib/action_controller/rack_process.rb
      @status = headers.delete("Status")
      if [204, 304].include?(status.to_i)
        headers.delete("Content-Type")
        [status, headers.to_hash, []]
=======
      normalize_headers(@headers)
      if [204, 304].include?(@status.to_i)
        @headers.delete "Content-Type"
        [status, @headers.to_hash, []]
>>>>>>> i18n:vendor/rails/actionpack/lib/action_controller/rack_process.rb
      else
<<<<<<< HEAD:vendor/rails/actionpack/lib/action_controller/rack_process.rb
        [status, headers.to_hash, self]
=======
        [status, @headers.to_hash, self]
>>>>>>> i18n:vendor/rails/actionpack/lib/action_controller/rack_process.rb
      end
    end
    alias to_a out

    def each(&callback)
      if @body.respond_to?(:call)
        @writer = lambda { |x| callback.call(x) }
        @body.call(self, self)
      elsif @body.is_a?(String)
        @body.each_line(&callback)
      else
        @body.each(&callback)
      end

      @writer = callback
      @block.call(self) if @block
    end

    def write(str)
      @writer.call str.to_s
      str
    end

    def close
      @body.close if @body.respond_to?(:close)
    end

    def empty?
      @block == nil && @body.empty?
    end

<<<<<<< HEAD:vendor/rails/actionpack/lib/action_controller/rack_process.rb
    def prepare!
      super
=======
    private
      def normalize_headers(options = "text/html")
        if options.is_a?(String)
          headers['Content-Type']     = options unless headers['Content-Type']
        else
          headers['Content-Length']   = options.delete('Content-Length').to_s if options['Content-Length']
>>>>>>> i18n:vendor/rails/actionpack/lib/action_controller/rack_process.rb

<<<<<<< HEAD:vendor/rails/actionpack/lib/action_controller/rack_process.rb
      convert_language!
      convert_expires!
      set_status!
      # set_cookies!
    end
=======
          headers['Content-Type']     = options.delete('type') || "text/html"
          headers['Content-Type']    += "; charset=" + options.delete('charset') if options['charset']
>>>>>>> i18n:vendor/rails/actionpack/lib/action_controller/rack_process.rb

<<<<<<< HEAD:vendor/rails/actionpack/lib/action_controller/rack_process.rb
    private
      def convert_language!
        headers["Content-Language"] = headers.delete("language") if headers["language"]
      end
=======
          headers['Content-Language'] = options.delete('language') if options['language']
          headers['Expires']          = options.delete('expires') if options['expires']
>>>>>>> i18n:vendor/rails/actionpack/lib/action_controller/rack_process.rb

<<<<<<< HEAD:vendor/rails/actionpack/lib/action_controller/rack_process.rb
      def convert_expires!
        headers["Expires"] = headers.delete("") if headers["expires"]
      end
=======
          @status = options.delete('Status') || "200 OK"
>>>>>>> i18n:vendor/rails/actionpack/lib/action_controller/rack_process.rb

<<<<<<< HEAD:vendor/rails/actionpack/lib/action_controller/rack_process.rb
      def convert_content_type!
        super
        headers['Content-Type'] = headers.delete('type') || "text/html"
        headers['Content-Type'] += "; charset=" + headers.delete('charset') if headers['charset']
      end
=======
          # Convert 'cookie' header to 'Set-Cookie' headers.
          # Because Set-Cookie header can appear more the once in the response body,
          # we store it in a line break separated string that will be translated to
          # multiple Set-Cookie header by the handler.
          if cookie = options.delete('cookie')
            cookies = []
>>>>>>> i18n:vendor/rails/actionpack/lib/action_controller/rack_process.rb

<<<<<<< HEAD:vendor/rails/actionpack/lib/action_controller/rack_process.rb
      def set_content_length!
        super
        headers["Content-Length"] = headers["Content-Length"].to_s if headers["Content-Length"]
      end
=======
            case cookie
              when Array then cookie.each { |c| cookies << c.to_s }
              when Hash  then cookie.each { |_, c| cookies << c.to_s }
              else            cookies << cookie.to_s
            end
>>>>>>> i18n:vendor/rails/actionpack/lib/action_controller/rack_process.rb

<<<<<<< HEAD:vendor/rails/actionpack/lib/action_controller/rack_process.rb
      def set_status!
        self.status ||= "200 OK"
      end
=======
            @request.cgi.output_cookies.each { |c| cookies << c.to_s } if @request.cgi.output_cookies
>>>>>>> i18n:vendor/rails/actionpack/lib/action_controller/rack_process.rb

<<<<<<< HEAD:vendor/rails/actionpack/lib/action_controller/rack_process.rb
      def set_cookies!
        # Convert 'cookie' header to 'Set-Cookie' headers.
        # Because Set-Cookie header can appear more the once in the response body,
        # we store it in a line break separated string that will be translated to
        # multiple Set-Cookie header by the handler.
        if cookie = headers.delete('cookie')
          cookies = []

          case cookie
            when Array then cookie.each { |c| cookies << c.to_s }
            when Hash  then cookie.each { |_, c| cookies << c.to_s }
            else            cookies << cookie.to_s
=======
            headers['Set-Cookie'] = [headers['Set-Cookie'], cookies].flatten.compact
>>>>>>> i18n:vendor/rails/actionpack/lib/action_controller/rack_process.rb
          end

<<<<<<< HEAD:vendor/rails/actionpack/lib/action_controller/rack_process.rb
          @cgi.output_cookies.each { |c| cookies << c.to_s } if @cgi.output_cookies

          headers['Set-Cookie'] = [headers['Set-Cookie'], cookies].flatten.compact
=======
          options.each { |k,v| headers[k] = v }
>>>>>>> i18n:vendor/rails/actionpack/lib/action_controller/rack_process.rb
        end
<<<<<<< HEAD:vendor/rails/actionpack/lib/action_controller/rack_process.rb
=======

        ""
>>>>>>> i18n:vendor/rails/actionpack/lib/action_controller/rack_process.rb
      end
  end

  class CGIWrapper < ::CGI
    attr_reader :output_cookies

    def initialize(request, *args)
      @request  = request
      @args     = *args
      @input    = request.body

      super *args
    end

    def params
      @params ||= @request.params
    end

    def cookies
      @request.cookies
    end

    def query_string
      @request.query_string
    end

    # Used to wrap the normal args variable used inside CGI.
    def args
      @args
    end

    # Used to wrap the normal env_table variable used inside CGI.
    def env_table
      @request.env
    end

    # Used to wrap the normal stdinput variable used inside CGI.
    def stdinput
      @input
    end
  end
end
