namespace :sidekiq do
  desc 'Quiet sidekiq (stop fetching new tasks from Redis)'
  task :quiet do
    on roles(:tasks) do |role|
      execute :systemctl, :'--user', :kill, '-s', 'SIGTSTP', 'mostransport-sidekiq-default',
        raise_on_non_zero_exit: false
    end
  end

  desc 'Stop sidekiq'
  task :stop do
    on roles(:tasks) do |role|
      execute :systemctl, :'--user', :stop, 'mostransport-sidekiq-default'
    end
  end

  desc 'Start sidekiq'
  task :start do
    on roles(:tasks) do |role|
      execute :systemctl, :'--user', :start, 'mostransport-sidekiq-default'
    end
  end

  desc 'Restart sidekiq'
  task :restart do
    invoke! 'sidekiq:stop'
    invoke! 'sidekiq:start'
  end
end
