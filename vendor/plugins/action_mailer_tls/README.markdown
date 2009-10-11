ActionMailerTLS
===============

Background
----------

This gem makes it trivial to send email through a Gmail account or a Google Apps for business email account.

This gem will only work on Ruby 1.8.6. If you're on Ruby 1.8.7 and Rails >= 2.2.1, you don't need this gem. See Notes below.

Installation
------------


To install the gem (the preferred way):

  1. `sudo gem install openrain-action_mailer_tls -s http://gems.github.com`
  2. `./script/generate action_mailer_tls`
  3. Copy RAILS_ROOT/config/smtp_gmail.yml.sample to RAILS_ROOT/config/smtp_gmail.yml
  4. Update the configuration file with your settings

To (optionally) vendor this gem:

  1. Add the following entry to config/environment.rb
    * config.gem "openrain-action_mailer_tls", :lib => "smtp_tls.rb", :source => "http://gems.github.com"
  2. rake gems:unpack

To install the plugin (the old way):

  1. `./script/plugin install git://github.com/openrain/action_mailer_tls.git -r 'tag v1.0.0'`
  2. Copy vendor/plugins/action_mailer_tls/sample/smtp_gmail.rb to config/
  3. Copy vendor/plugins/action_mailer_tls/sample/mailer.yml.sample to config/
  4. Update the configuration file with your settings

Testing it out
--------------

  1. `./script/generate mailer Notifier hello_world`
  2. Add the following lines to config/environments/development.rb 
    * config.action_mailer.raise_delivery_errors = true
    * config.action_mailer.perform_deliveries = true
    * config.action_mailer.delivery_method = :smtp
  3. Update the recipients and from fields in app/models/notifier.rb
  4. `./script/console `
  5. `Notifier.deliver_hello_world!`

Resources
---------

Blog posts

* [How to use Gmail's SMTP server with Rails](http://www.rubyinside.com/how-to-use-gmails-smtp-server-with-rails-394.html)
* [Configuring Rails to use Gmail's SMTP server](http://www.prestonlee.com/2007/02/20/configuring-rails-to-use-gmails-smtp-server/63/)

Books

* This gem was also featured in Advanced Rails Recipes pg. 238, Recipe #47.

Notes
-----

If you're running Rails >= 2.2.1 [RC2] and Ruby 1.8.7, you don't need this gem. Ruby 1.8.7 supports
SMTP TLS and Rails 2.2.1 ships with an option to enable it if you're running Ruby 1.8.7.

  To set it all up, in config/initializers/smtp_gmail.rb, make sure to set `:enable_starttls_auto` to `true`.
    ActionMailer::Base.smtp_settings = {
      :address => "smtp.gmail.com",
      :port => 587,
      :authentication => :plain,
      :enable_starttls_auto => true,
      :user_name => "noreply@gmail_or_your_google_domain.com",
      :password => "chucknorris"
    }



For more information on this feature, check out the [commit log](http://github.com/rails/rails/commit/732c724df61bc8b780dc42817625b25a321908e4)

Author
------
* Marc Chung - marc [dot] chung [at] openrain [dot] com

