ARG PYTHON_VERSION=3
FROM python:$PYTHON_VERSION-alpine

# persistent / runtime deps
RUN apk add --no-cache \
		ca-certificates \
		postgresql-client \
	;

ARG OPENSTACK_CLIENT_VERSION=0.1.0
RUN set -eux; \
	apk add --no-cache --virtual .build-deps \
		gcc \
		libffi-dev \
		musl-dev \
		openssl-dev \
		python3-dev \
	; \
	\
	pip install --no-cache-dir \
		openstackclient==${OPENSTACK_CLIENT_VERSION} \
	; \
	\
	apk del .build-deps; \
	\
	openstack --version

ARG GO_CRON_VERSION=0.0.7
RUN set -eux; \
	apk add --no-cache --virtual .fetch-deps \
		wget \
	; \
	\
	wget -O - "https://github.com/odise/go-cron/releases/download/v$GO_CRON_VERSION/go-cron-linux.gz" | zcat > /usr/local/bin/go-cron; \
	chmod +x /usr/local/bin/go-cron; \
	\
	apk del .fetch-deps

COPY backup.sh /usr/local/bin/backup
RUN chmod +x /usr/local/bin/backup

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]
CMD ["backup"]
