# Capistrano 1 recipe example for Media Temple (gs)

require 'mt-capistrano'

set :site,         "0000"
set :application,  "appname"
set :webpath,      "app.com"
set :domain,       "app.com"
set :user,         "serveradmin%app.com"
set :password,     "password"

ssh_options[:username] = 'serveradmin%app.com'

set :repository, "http://eldorado.googlecode.com/svn/current/"
set :deploy_to,  "/home/#{site}/containers/rails/#{application}"

set :checkout, "export"

role :web, "#{domain}"
role :app, "#{domain}"
role :db,  "#{domain}", :primary => true

task :after_update_code, :roles => :app do
  put(File.read('config/database.yml'), "#{release_path}/config/database.yml", :mode => 0444)
  %w{avatars files headers}.each do |share|
    run "rm -rf #{release_path}/public/#{share}"
    run "mkdir -p #{shared_path}/system/#{share}"
    run "ln -nfs #{shared_path}/system/#{share} #{release_path}/public/#{share}"
  end
end

task :restart, :roles => :app do
  run "mtr restart #{application} -u #{user} -p #{password}"
  run "mtr generate_htaccess #{application} -u #{user} -p #{password}"
end
