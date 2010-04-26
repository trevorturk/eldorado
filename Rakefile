# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

# http://almosteffortless.com/2010/04/14/automated-heroku-backups/
namespace :heroku do
  desc "PostgreSQL database backups from Heroku to Amazon S3"
  task :backup => :environment do
    begin
      require 'right_aws'
      puts "[#{Time.now}] heroku:backup started"
      name = "#{ENV['APP_NAME']}-#{Time.now.strftime('%Y-%m-%d-%H%M%S')}.dump"
      db = ENV['DATABASE_URL'].match(/postgres:\/\/([^:]+):([^@]+)@([^\/]+)\/(.+)/)
      system "PGPASSWORD=#{db[2]} pg_dump -Fc --username=#{db[1]} --host=#{db[3]} #{db[4]} > tmp/#{name}"
      s3 = RightAws::S3.new(ENV['s3_access_key_id'], ENV['s3_secret_access_key'])
      bucket = s3.bucket("#{ENV['APP_NAME']}-heroku-backups", true, 'private')
      bucket.put(name, open("tmp/#{name}"))
      system "rm tmp/#{name}"
      puts "[#{Time.now}] heroku:backup complete"
    rescue Exception => e
      require 'toadhopper'
      Toadhopper(ENV['hoptoad_key']).post!(e)
    end
  end
end

task :cron => :environment do
  Rake::Task['heroku:backup'].invoke
end
