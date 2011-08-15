set :application, "calagator_techclt"
set :repository,  "git@github.com:charlotte-ruby/calagator.git"
set :scm, :git
set :use_sudo,    false
set :deploy_to,   "/rails_apps/#{application}"
set :user, "app_user"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

server "174.143.150.37", :app, :web, :db, :primary => true

namespace :deploy do
  task :start, :roles => :app do
    #run "touch #{current_release}/tmp/restart.txt"
    run "thin start -C /rails_apps/#{application}/current/config/thin.yml" #Thin
  end

  task :stop, :roles => :app do
    # Do nothing.
    run "thin stop -C /rails_apps/#{application}/current/config/thin.yml" #Thin
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    #run "touch #{current_release}/tmp/restart.txt"
    run "thin restart --onebyone -C /rails_apps/#{application}/current/config/thin.yml" #Thin
  end
  
  desc "Stop Nginx"
  task :stop_nginx, :roles => :app do
    run ""
  end
end