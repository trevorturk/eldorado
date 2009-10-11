# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{action_mailer_tls}
  s.version = "1.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marc Chung"]
  s.date = %q{2009-02-11}
  s.description = %q{Conveniently send emails through Google's Hosted App service}
  s.email = %q{marc.chung@openrain.com}
  s.files = ["History.txt", "README.markdown", "VERSION.yml", "generators/USAGE", "generators/action_mailer_tls_generator.rb", "generators/templates", "generators/templates/config", "generators/templates/config/initializers", "generators/templates/config/initializers/smtp_gmail.rb", "generators/templates/config/smtp_gmail.yml.sample", "lib/smtp_tls.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/openrain/action_mailer_tls}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Send Email via Gmail}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
