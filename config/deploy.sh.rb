# Capistrano 2 recipe example for Slicehost (Debian Etch)

set :application, "eldorado"
set :repository,  "http://eldorado.googlecode.com/svn/trunk/"
set :deploy_to, "/home/eldorado"
set :deploy_via, :export
set :user, 'root'

ssh_options[:port] = 22

role :app, "000.00.00.000"
role :web, "000.00.00.000"
role :db,  "000.00.00.000", :primary => true

after 'deploy:update_code', 'deploy:upload_database_yml'
after 'deploy:update_code', 'deploy:create_symlinks'

namespace :deploy do
  task :restart do
    run "/var/lib/gems/1.8/bin/mongrel_rails stop -P #{shared_path}/log/mongrel.8000.pid"
    run "/var/lib/gems/1.8/bin/mongrel_rails start -d -e production -p 8000 -P log/mongrel.8000.pid -c #{release_path} --user root --group root"
  end
end

namespace :deploy do
  task :upload_database_yml do
    put(File.read('config/database.yml'), "#{release_path}/config/database.yml", :mode => 0444)    
  end
end

namespace :deploy do
  task :create_symlinks do
    %w{avatars files headers}.each do |share|
      run "rm -rf #{release_path}/public/#{share}"
      run "mkdir -p #{shared_path}/system/#{share}"
      run "ln -nfs #{shared_path}/system/#{share} #{release_path}/public/#{share}"
    end
  end
end
