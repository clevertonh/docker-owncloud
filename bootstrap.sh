#!/bin/bash
set -e

cp -r /var/www/apps.dist/* /var/www/apps

chown -R www-data:www-data /var/www/apps /var/www/config /var/www/data

if [ "$1" = '/run.sh' ]; then
	exec /run.sh "$@"
fi

exec "$@"
