#!/bin/bash
if [ "x$1" = "x-h" -o "x$1" = "x" ] ; then
    echo "Usage: $0 SERVICE_NAME"
    echo "Runs 'docker service ps magento_SERVICENAME', but shows only running processes."
    exit 0
fi
docker service ps "magento_$1" --filter desired-state=running
