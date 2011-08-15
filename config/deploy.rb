set :application, "calagator_techclt"
set :repository,  "git@github.com:charlotte-ruby/calagator_techclt.git"
set :scm, :git
set :use_sudo,    false
set :deploy_to,   "/rails_apps/#{application}"
set :user, "app_user"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

server "174.143.150.37", :app, :web, :db, :primary => true

# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

# Load RVM's capistrano plugin.    
require "rvm/capistrano"

set :rvm_bin_path, "/home/app_user/.rvm/bin/"
set :rvm_ruby_string, '1.8.7'
set :rvm_type, :user

namespace :deploy do
  task :start, :roles => :app do
    run "~/.rvm/gems/ruby-1.8.7-p334/bin/thin start -C /rails_apps/#{application}/current/config/thin.yml" #Thin
  end

  task :stop, :roles => :app do
    # Do nothing.
    run "~/.rvm/gems/ruby-1.8.7-p334/bin/thin stop -C /rails_apps/#{application}/current/config/thin.yml" #Thin
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "~/.rvm/gems/ruby-1.8.7-p334/bin/thin restart --onebyone -C /rails_apps/#{application}/current/config/thin.yml" #Thin
  end
  
  desc "Stop Nginx"
  task :stop_nginx, :roles => :app do
    run ""
  end
end