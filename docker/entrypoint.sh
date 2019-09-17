#!/usr/bin/env ash
set -e
set -x

# TODO: in Dockerfile or manual setup
# Set default environment variables
export FOREMAN_OPTS=${FOREMAN_OPTS:-""}
export RAILS_ENV=${RAILS_ENV:-production}
export RAILS_LOG_TO_STDOUT=${RAILS_LOG_TO_STDOUT:-true}

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
