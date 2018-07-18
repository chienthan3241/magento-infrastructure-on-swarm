#!/bin/bash
container=$(
    docker ps | while read id name dummy; do
        case "$name" in
        registry.devgmt.com/gmt/rsyncer-swarm:*)
            echo $id
	    break
            ;;
        esac
    done
)

if [ "x$container" = "x" ]; then
    echo "ERROR: Couldn't find container for registry.devgmt.com/gmt/rsyncer-swarm"
    echo "You might be on the wrong node.  Maybe the following output helps to"
    echo "find the right node."
    echo "==> bin/find-service.sh rsyncmaster"
    bin/find-service.sh rsyncmaster
    echo "==> Bailing out."
    exit 1
fi

docker exec -it $container bash
