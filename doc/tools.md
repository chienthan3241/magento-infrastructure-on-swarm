# Useful Tools

This page documents the tools included in this repo.  All the tools
are in the `bin/` subdirectory.  Many tools assume that you are
running from the root directory of this git repo, so the tools assume
that you call them as `bin/foo.sh`.

Most of the tools expect to be run on a node that's part of the swarm.
Exceptions will be noted.

## after-reboot-prod.sh

Performs the necessary steps after rebooting a production node.  Must
be run as root.

## after-restore.sh

Sets the base URL of the Magento installation.  You need this when
you take a production DB dump (say) and restore it in staging (say).

## cron.sh

Runs a shell in the `applicationcron` container.  The shell will be
run as user `www-data`; unless you pass `-r`, then it will run as
`root`.

## dbdump.sh

Dump the database and put it into the file `prod.sql` in the current
directory.  Often, you would copy this file to another place
afterwards.  Also see `dbrestore.sh`.

## dbrestore.sh

Restore the database from the file `prod.sql` in the current
directory.

## deploy-stack.sh

This is a wrapper around `docker stack deploy`, but our setup requires
an environment variable to be specified, so it makes sense to extract
that into a shell script.

## find-service.sh

Find the nodes that run a given service.  You are not supposed to
include the `magento_` prefix.  Example:

    bin/find-service.sh applicationcron

## generate-documentation.sh

This creates the `html` directory and then populates it with an HTML
version of each of the Markdown files.

You would normally call this on your Mac.  Uses `pandoc` to do the
conversion.  Use `brew install pandoc` to install that tool.  (See
https://brew.sh for more information about Homebrew.)

## magento.sh

Runs a shell in an `applicationphp` container.  The shell runs as user
`www-data`; unless you pass `-r`, then it runs as user `root`.

## rebalance-all-services.sh

Runs `docker service update --force` on each running service.  This
is useful because replicated services might not be distributed evenly
amongst the nodes.  For example, when you reboot a node, no services
will be running on it initially.

## restart-caches.sh

Restarts all the caches we've got:

* Full page varnish cache
* Redis cache (what's cached in Redis?)

## run-magento-updates.sh

Run all the upgrade steps that need to run, after a Magento "upgrade".
Actually, this would also be useful after restoring a database.

Specifically, it runs:

* `bin/magento setup:upgrade`
* `bin/magento setup:di:compile`
* `bin/magento setup:static-content:deploy de_DE en_US`
* Copy the `js-translation.json` file to the right place



