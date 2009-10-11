# This generator intalls ActionMailerTLS into a Rails project
class ActionMailerTlsGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.file "config/smtp_gmail.yml.sample",        "config/smtp_gmail.yml.sample"
      m.file "config/initializers/smtp_gmail.rb",   "config/initializers/smtp_gmail.rb"
    end
  end

end