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

    docker run -d --name owncloud-postgres --volumes-from your-dbdata-container postgres
    docker run -d --name clamavd dinkel/clamavd

The run this image

    docker run -d --name owncloud -p 80:80 --volumes-from your-data-container --link owncloud-postgres:owncloud-postgres --link clamavd:clamavd dinkel/owncloud

Upon first launch, one has to configure ownCloud appropriately. See ownClouds
own documentation for details. Note that the hostnames of linked functionality
(database or ClamAV daemon) in the configuration is the part behind the colon.

Configuration (environment variables)
-------------------------------------

None at the moment.

Data persistence
----------------

The image exposes threee directories
(`VOLUME ["/var/www/apps", "/var/www/config", "/var/www/data"]`) - one that
holds the configured apps, one with configuration options and the last one
with the files that are being saved in ownCloud. Please make sure that these
directories are saved (in a data-only container or alike) in order to make sure
that everything is restored after a new restart of the application.

Update
------

### Form 8.0.x to 8.1.x

As the Antivirus app is now considered official, one has to eanble it through
the normal Apps system. To have it work flawlessly, one needs to delete the
`oc_files_antivirus` table before upgrading. Also I had to reconfigure the app
to make it delete the files in the Admin section and also I needed to reset the
rules in the advanced tab. Definitely make sure to test everything with an EICAR
file.

In my case (while testing the build) it was quite annoying to update all apps,
but with a little bit of patience and a combination of updating, uninstalling
and installing apps one a the time, it worked for me.
