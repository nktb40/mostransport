namespace :deploy do
  desc 'Setup configs'
  task :setup_configs do
    on roles(:all), in: :parallel do |_host|
      # prepare database config
      execute :cp, '-a', "#{release_path}/config/database/#{fetch(:stage)}.yml #{release_path}/config/database.yml"
    end
  end
end
