#!/bin/bash
set -e

# Ensure all required gems are installed
bundle check || bundle install --jobs 4

# Remove the server.pid file if it exists
rm -f tmp/pids/server.pid

# Run database setup
bundle exec rake db:prepare
bundle exec rake db:seed

# Start tailwind watcher in the background
bundle exec rails tailwindcss:watch[always] &

# Start Rails server
exec bundle exec rails s -p 3000 -b '0.0.0.0'