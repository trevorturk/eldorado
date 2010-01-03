load 'deploy' if respond_to?(:namespace) # cap2 differentiator

set :repository, 'git://github.com/trevorturk/eldorado.git'
set :scm, :git
set :deploy_via, :copy
set :git_shallow_clone, 1

set :application, 'eldorado'
set :deploy_to, '/home/eldorado'

role :app, "000.00.00.000"
role :web, "000.00.00.000"
role :db,  "000.00.00.000", :primary => true

before  'deploy:update_code', 'deploy:web:disable'
after   'deploy:update_code', 'deploy:upload_config_files'
after   'deploy:update_code', 'deploy:create_symlinks'
after   'deploy:update_code', 'deploy:bundler'
after   'deploy:restart', 'deploy:cleanup'
after   'deploy:restart', 'deploy:web:enable'

namespace :deploy do
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
  task :upload_config_files do
    put(File.read('config/config.yml'), "#{release_path}/config/config.yml", :mode => 0444)
    put(File.read('config/database.yml'), "#{release_path}/config/database.yml", :mode => 0444)
    # For security consider uploading a production-only configs to your server and using this instead:
    # run "ln -nfs #{shared_path}/config/config.yml #{release_path}/config/config.yml"
    # run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  task :bundler do
    run "cd #{release_path} && gem bundle"
  end
  task :create_symlinks do
    require 'yaml'
    download "#{release_path}/config/symlinks.yml", "/tmp/eldorado_symlinks.yml"
    YAML.load_file('/tmp/eldorado_symlinks.yml').each do |share|
      run "rm -rf #{release_path}/public/#{share}"
      run "mkdir -p #{shared_path}/system/#{share}"
      run "ln -nfs #{shared_path}/system/#{share} #{release_path}/public/#{share}"
    end
  end
end