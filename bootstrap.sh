#!/bin/bash
set -e

cd /var/www/apps.dist/ && find . -maxdepth 1 -mindepth 1 -type d -exec rm -rf ../apps/{} \;
cp -r /var/www/apps.dist/* /var/www/apps

if [[ -f /var/www/config/config.php ]]; then
    sed -i "s/^\\s*'memcache.local'.*$//g" /var/www/config/config.php
    sed -i "s/^);$/  'memcache.local' => '\\\OC\\\Memcache\\\APCu',\\n);/" /var/www/config/config.php
else
    touch /var/www/config/config.php
    printf "<?php\n\$CONFIG = array (\n  'memcache.local' => '\\OC\\Memcache\\APCu',\n);" > /var/www/config/config.php
fi

chown -R www-data:www-data /var/www/apps /var/www/config /var/www/data

if [ "$1" = '/run.sh' ]; then
	exec /run.sh "$@"
fi

exec "$@"
