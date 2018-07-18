# How to do a deployment in staging or production

## git pull

On one of the servers, perform the `git pull` as follows.  Today, 2018-06-06,
this only works on `gmt-stage-1`, but we want to create the `www-data` user
on all servers, then it will work on any server.

    ssh xy@gmt-stage-1.devgmt.com       # your user instead of xy
    ssh www-data@localhost              # has to be invoked from there
    cd /data/docker/volumes/magento_appdata/_data
    git pull

Note that this means the `git pull` happens outside of any container.

Note that the `cd` step might fail due to missing permissions. Fix it as
follows:

    ssh xy@gmt-stage-1.devgmt.com
    sudo -i
    chmod a+rx /data /data/docker /data/docker/volumes

I think the permissions disappear after a reboot.  Not sure how to make
them stick.

## Empty the generated files

On each server, empty generated files:

    sudo -i             # become root
    cd /data/docker/volumes/magento_appdata/_data
    bin/delete-generated-directories.sh

(Maybe we need to move this step to a later point because the shop can't run
without these files.)

## Run the Magento CLI

The Magento CLI has to be executed inside the `applicationphp` container,
but there is a helper script that does this for you.  So from any host
in the swarm, at the top of this git repo, do:

    bin/run-magento-updates.sh

The above command finds the right Docker container and then executes the
Magento CLI inside that container.

## Restart all caches

I think the next step is to restart all services that are related to caching:

    bin/restart-caches.sh

## Potential other steps that I hope are not needed

Do we need to manually invoke the rsyncer? I hope not. Maybe you can `touch
kai_was_here.txt` to tickle the rsyncer.

I think nothing is visible in the browser unless you clear all browsing data.
In Safari, go to Preferences / Privacy, then click the Manage Website Data
button. Then enter `devgmt` (for staging) or `germantom` (for production)
into the search field, depending on the URL of the Magento environment. Then
select `devgmt.com` or `germantom.com` from the list and click "Remove".
Close the preferences window.

TODO: What about the `js-translation.json` file?  Need to address this!
