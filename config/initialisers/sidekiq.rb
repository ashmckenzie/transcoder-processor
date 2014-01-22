require 'sidekiq'
require 'sidekiq-failures'

Sidekiq.configure_client do |config|
  config.redis = { namespace: 'transcoder-processor' }
end

Sidekiq.configure_server do |config|
  config.redis = { namespace: 'transcoder-processor' }
end
