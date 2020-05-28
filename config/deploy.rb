# config valid for current version and patch releases of Capistrano
lock "~> 3.14.0"

set :application, "mostransport"
set :repo_url, "git@github.com:nktb40/mostransport.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/mostransport/mostransport"

# Default value for :format is :airbrussh.
set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, ".env"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "storage", "uploads",
  "public/packs", "public/uploads"

# Bundler integration
append :bundle_bins, 'puma', 'pumactl'

# Rbenv integration
append :rbenv_map_bins, 'puma', 'pumactl'

set :nvm_type, :user
set :nvm_node, 'v10.18.1'

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 7

# Uncomment the following to require manually verifying the host key before first deploy.
set :ssh_options, verify_host_key: :always

set :bundle_bins, %w{rake rails}

namespace :deploy do
  after 'symlink:shared', 'deploy:setup_configs'
  after 'symlink:shared', 'deploy:setup_bundler'
  after 'deploy:publishing', 'puma:phased-restart'
  after 'deploy:publishing', 'sidekiq:quiet'
  after 'deploy:published', 'sidekiq:stop'
  after 'deploy:published', 'sidekiq:start'
  after 'deploy:failed', 'sidekiq:restart'
  after 'deploy:published', 'sitemap:refresh'
end
