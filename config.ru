require 'sidekiq/web'
require './web_app'

run Rack::URLMap.new(
  '/' => WebApp,
  '/sidekiq' => Sidekiq::Web
)
