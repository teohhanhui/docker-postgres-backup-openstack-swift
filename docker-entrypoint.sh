#!/bin/sh
set -e

export PGPASSWORD=$POSTGRES_PASSWORD

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- backup "$@"
fi

if [ -n "${SCHEDULE-}" ]; then
	set -- go-cron "$SCHEDULE" "$@"
fi

exec "$@"
