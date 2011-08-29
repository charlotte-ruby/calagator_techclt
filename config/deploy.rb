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

set :rvm_bin_path, "$HOME/.rvm/bin"
set :rvm_ruby_string, '1.8.7@calagator'
set :rvm_type, :user

namespace :deploy do
  task :start, :roles => :app do
    run "cd /rails_apps/#{application}/current;mongrel_rails cluster::start"
  end

  task :stop, :roles => :app do
    run "cd /rails_apps/#{application}/current;mongrel_rails cluster::stop"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "cd /rails_apps/#{application}/current;mongrel_rails cluster::restart"
  end
end

task :after_symlink do
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end