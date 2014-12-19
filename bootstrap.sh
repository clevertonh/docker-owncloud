#!/bin/bash
set -e

chown -R www-data:www-data /var/www/config /var/www/data

if [ "$1" = '/run.sh' ]; then
	exec /run.sh "$@"
fi

exec "$@"
