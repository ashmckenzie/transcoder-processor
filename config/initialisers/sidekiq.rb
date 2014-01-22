require 'sidekiq'
require 'sidekiq-status'
require 'sidekiq-failures'

Sidekiq.configure_client do |config|
  config.redis = { namespace: 'transcoder-processor' }

  config.client_middleware do |chain|
    chain.add Sidekiq::Status::ClientMiddleware
  end
end

Sidekiq.configure_server do |config|
  config.redis = { namespace: 'transcoder-processor' }

  config.server_middleware do |chain|
    chain.add Sidekiq::Status::ServerMiddleware, expiration: nil
  end

  config.client_middleware do |chain|
    chain.add Sidekiq::Status::ClientMiddleware
  end
end
