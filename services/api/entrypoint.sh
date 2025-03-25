#!/bin/bash
set -e

# Remove the server.pid file if it exists
rm -f tmp/pids/server.pid

# Run database tasks: drop, create, migrate, and seed
bundle exec rake db:prepare
bundle exec rake db:seed

# Execute the command passed to the container (e.g., Rails server)
exec "$@"
