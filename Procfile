web: mkdir -p tmp/pids > /dev/null 2>&1 ; bundle exec puma --port 7777
sidekiq: bundle exec sidekiq -v -c 2 -r ./config/initialise.rb
