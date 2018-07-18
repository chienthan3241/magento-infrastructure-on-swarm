#!/bin/bash

if [ -f ~/.docker/config.json ]; then
    :
else
    echo "ERROR: You are not logged into the docker registry."
    echo "(~/.docker/config.json does not exist.)"
    exit 1
fi
if grep -q registry.devgmt.com ~/.docker/config.json; then
    :
else
    echo "ERROR: You are not logged into the registry.devgmt.com docker registry."
    echo "(The string registry.devgmt.com is not in ~/.docker/config.json.)"
    exit 1
fi

if [ "x$1" = "x-s" ]; then
    echo "Updating stack for staging"
    POSTFIX_HOSTNAME=staging.devgmt.com
    FRONTEND_CERT=staging
elif [ "x$1" = "x-p" ]; then
    echo "Updating stack for production"
    POSTFIX_HOSTNAME=www.germantom.com
    FRONTEND_CERT=site
else
    echo "ERROR: One of '-s' (staging) or '-p' (production) must be specified."
    exit 1
fi

export POSTFIX_HOSTNAME FRONTEND_CERT

echo "Using POSTFIX_HOSTNAME=$POSTFIX_HOSTNAME"

DEPLOYMENT="$(whoami)@$(hostname)--$(date '+%FT%R')--$(git describe --tags --always --dirty)"
export DEPLOYMENT
echo "Using deployment indicator: $DEPLOYMENT"

docker stack up -c docker-compose.yml --with-registry-auth magento

echo "All done."
