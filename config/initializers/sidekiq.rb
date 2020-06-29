redis = YAML.load(ERB.new(File.read(Rails.root.join('config', 'redis.yml'))).result)
redis_config = redis.fetch(Rails.env)
redis_config.deep_symbolize_keys!

Sidekiq.configure_server do |config|
  config.redis = redis_config
  #schedule_file = "config/schedule.yml"
  #if File.exists?(schedule_file)
  #  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  #end
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end
