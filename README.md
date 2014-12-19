docker-owncloud
===============

Yet another Docker image with ownCloud. This one bases on my own
"implementation" of a
[Nginx and PHP-FPM image](https://github.com/dinkel/docker-nginx-phpfpm) and
features a separate data container, possibly links to a database container as
well as to a ClamAV container (like
[this one](https://github.com/dinkel/docker-clamavd)) and allows big file
uploads.

NOTE: Never expose this application directly to the internet as it runs as
insecure HTTP only - on purpose. It is expected that this application resides
behind a reverse proxy of some kind that deals with securing the site.

Usage
-----

The most simple form would be to start the application like so:

    docker run -d -p 80:80 dinkel/owncloud

This would allow for a SQLite3 installation (make sure to configure the database
file resides in `/var/www/data` for persistence).

To get the full potential this image offers, one should first create a data-only
container (see "Data persistence" below), and start a database daemon (which
itself should have a data-only container) and a ClamAV daemon:

    docker run -d -name owncloud-postgres --volumes-from your-dbdata-container postgres
    docker run -d -name clamavd dinkel/clamavd

The run this image

    docker run -d -name owncloud --volumes-from your-data-container --link owncloud-postgres:owncloud-postgres --link clamavd:clamavd dinkel/owncloud

Upon first launch, one has to configure ownCloud appropriately. See ownClouds
own documentation for details. Note that the hostnames of linked functionality
(database or ClamAV daemon) in the configuration is the part behind the colon.

Configuration (environment variables)
-------------------------------------

None at the moment.

Data persistence
----------------

The image exposes two directories
(`VOLUME ["/var/www/config", "/var/www/data"]`) - one with configuration options
and one with the files that are being saved in ownCloud. Please make sure that
these directories are saved (in a data-only container or alike) in order to make
sure that everything is restored after a new restart of the application.

Todo
----

* Installing additional ownCloud apps (plugins) are written inside the container
  and not reflected to the outside world (a.k.a. a data container), because in
  `/var/www/apps` there are already the default apps installed. There is a
  possibility to make a second app directory (see "Apps configuration" in the
  ownCloud Administrators Manual), but within Docker this would require to put
  stuff in `/var/www/config/config.php` from within the `bootstrap.sh` script,
  which could be quite tricky.
