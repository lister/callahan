

# deploy.rb
set :application, "callahan.smadget.at"
role :app, application
role :web, application
role :db,  application, :primary => true

set :user, "callahan"
set :deploy_to, "/srv/www/vhosts/#{application}/httpdocs/callahan_source"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :scm_verbose, true
set :repository, "git@github.com:lister/callahan.git"
set :branch, "master"

namespace :deploy do
  desc "Tell Passenger to restart the app."
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  desc "Insert database seed."
  task :seed do
    run "cd #{current_path}; rake RAILS_ENV=production db:seed"
  end
 
  desc "Insert database seed."
  task :gems do
    run "cd #{current_path}; rake RAILS_ENV=production gems:install"
  end
 
end

after 'deploy:update_code', 'deploy:symlink_shared'


