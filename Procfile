web: mkdir -p tmp/pids > /dev/null 2>&1 ; bundle exec puma --port 7777
sidekiq: bundle exec sidekiq -C ./config/sidekiq.yml -r ./config/initialise.rb
