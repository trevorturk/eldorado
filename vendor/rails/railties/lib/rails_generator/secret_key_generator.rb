module Rails
  # A class for creating random secret keys. This class will do its best to create a
  # random secret key that's as secure as possible, using whatever methods are
  # available on the current platform. For example:
  #
  #   generator = Rails::SecretKeyGenerator("some unique identifier, such as the application name")
  #   generator.generate_secret     # => "f3f1be90053fa851... (some long string)"
  #
  # This class is *deprecated* in Rails 2.2 in favor of ActiveSupport::SecureRandom.
  # It is currently a wrapper around ActiveSupport::SecureRandom.
  class SecretKeyGenerator
    def initialize(identifier)
    end

    # Generate a random secret key with the best possible method available on
    # the current platform.
    def generate_secret
<<<<<<< HEAD:vendor/rails/railties/lib/rails_generator/secret_key_generator.rb
      ActiveSupport::SecureRandom.hex(64)
=======
      generator = GENERATORS.find do |g|
        self.class.send("supports_#{g}?")
      end
      send("generate_secret_with_#{generator}")
    end

    # Generate a random secret key by using the Win32 API. Raises LoadError
    # if the current platform cannot make use of the Win32 API. Raises
    # SystemCallError if some other error occurred.
    def generate_secret_with_win32_api
      # Following code is based on David Garamond's GUID library for Ruby.
      require 'Win32API'

      crypt_acquire_context = Win32API.new("advapi32", "CryptAcquireContext",
                                           'PPPII', 'L')
      crypt_gen_random = Win32API.new("advapi32", "CryptGenRandom",
                                      'LIP', 'L')
      crypt_release_context = Win32API.new("advapi32", "CryptReleaseContext",
                                         'LI', 'L')
      prov_rsa_full       = 1
      crypt_verifycontext = 0xF0000000

      hProvStr = " " * 4
      if crypt_acquire_context.call(hProvStr, nil, nil, prov_rsa_full,
                                    crypt_verifycontext) == 0
        raise SystemCallError, "CryptAcquireContext failed: #{lastWin32ErrorMessage}"
      end
      hProv, = hProvStr.unpack('L')
      bytes = " " * 64
      if crypt_gen_random.call(hProv, bytes.size, bytes) == 0
        raise SystemCallError, "CryptGenRandom failed: #{lastWin32ErrorMessage}"
      end
      if crypt_release_context.call(hProv, 0) == 0
        raise SystemCallError, "CryptReleaseContext failed: #{lastWin32ErrorMessage}"
      end
      bytes.unpack("H*")[0]
    end

    # Generate a random secret key with Ruby 1.9's SecureRandom module.
    # Raises LoadError if the current Ruby version does not support
    # SecureRandom.
    def generate_secret_with_secure_random
      require 'securerandom'
      return SecureRandom.hex(64)
    end

    # Generate a random secret key with OpenSSL. If OpenSSL is not
    # already loaded, then this method will attempt to load it.
    # LoadError will be raised if that fails.
    def generate_secret_with_openssl
      require 'openssl'
      if !File.exist?("/dev/urandom")
        # OpenSSL transparently seeds the random number generator with
        # data from /dev/urandom. On platforms where that is not
        # available, such as Windows, we have to provide OpenSSL with
        # our own seed. Unfortunately there's no way to provide a
        # secure seed without OS support, so we'll have to do with
        # rand() and Time.now.usec().
        OpenSSL::Random.seed(rand(0).to_s + Time.now.usec.to_s)
      end
      data = OpenSSL::BN.rand(2048, -1, false).to_s

      if OpenSSL::OPENSSL_VERSION_NUMBER > 0x00908000
        OpenSSL::Digest::SHA512.new(data).hexdigest
      else
        generate_secret_with_prng
      end
>>>>>>> i18n:vendor/rails/railties/lib/rails_generator/secret_key_generator.rb
    end
    deprecate :generate_secret=>"You should use ActiveSupport::SecureRandom.hex(64)"
  end
end
