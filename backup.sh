#!/bin/sh
set -e

pg_dump_opts="--host=$POSTGRES_HOST --port=${POSTGRES_PORT:-5432} --username=${POSTGRES_USER:-postgres} --dbname=$POSTGRES_DB${POSTGRES_EXTRA_OPTS-}"
pg_dump_file=$(mktemp)

echo "Creating dump of $POSTGRES_DB database from $POSTGRES_HOST..."

pg_dump $pg_dump_opts | gzip > "$pg_dump_file"

echo "Uploading dump to $SWIFT_CONTAINER_NAME"

openstack object create \
	--name "${SWIFT_NAME_PREFIX-}${POSTGRES_DB}_$(date +"%Y-%m-%dT%H:%M:%SZ").sql.gz" \
	"$SWIFT_CONTAINER_NAME" \
	"$pg_dump_file"

echo "SQL backup uploaded successfully"
