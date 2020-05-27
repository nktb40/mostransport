namespace :puma do
  %w[phased-restart restart].map do |command|
    desc "#{command} puma"
    task command do
      on roles(:app) do |role|
        within current_path do
          execute :pumactl, "-F config/puma/server_config.rb #{command}"
        end
      end
    end
  end
end
