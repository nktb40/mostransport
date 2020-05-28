namespace :deploy do
  desc 'Setup bundler'
  task :setup_bundler do
    on roles(:all), in: :parallel do |_host|
      # install bundler
      within release_path do                                                  
      	#execute 'gem',:install,:bundler,"'-v'","'~>2.0'"
      	#execute "gem install bundler '-v' '~>2.0'"
      	execute :gem,:install,:bundler,"'-v'","'~>2.0'"
      end
    end
  end
end
