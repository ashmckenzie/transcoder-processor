require 'sidekiq'
require 'sidekiq-failures'

redis_options = { url: TranscoderProcessor::Config.instance.redis.url, namespace: 'transcoder-processor' }

Sidekiq.configure_client do |config|
  config.redis = redis_options
end

Sidekiq.configure_server do |config|
  config.redis = redis_options
end
