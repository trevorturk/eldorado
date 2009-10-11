begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "action_mailer_tls"
    s.summary = "Send Email via Gmail"
    s.email = "marc.chung@openrain.com"
    s.homepage = "http://github.com/openrain/action_mailer_tls"
    s.description = "Conveniently send emails through Google's Hosted App service"
    s.authors = ["Marc Chung"]
    s.files = FileList["[A-Z]*.*", "{bin,generators,lib,test,spec}/**/*"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'action_mailer_tls'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# require 'rake/testtask'
# Rake::TestTask.new(:test) do |t|
#   t.libs << 'lib' << 'test'
#   t.pattern = 'test/**/*_test.rb'
#   t.verbose = false
# end
# 
# begin
#   require 'rcov/rcovtask'
#   Rcov::RcovTask.new do |t|
#     t.libs << 'test'
#     t.test_files = FileList['test/**/*_test.rb']
#     t.verbose = true
#   end
# rescue LoadError
#   puts "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
# end

task :default => :test