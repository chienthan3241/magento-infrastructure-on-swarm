#!/bin/bash
container=$(
    docker ps | while read id name dummy; do
        case "$name" in
        registry.devgmt.com/gmt/cron-swarm*)
            echo $id
	    break
            ;;
        esac
    done
)

if [ "x$1" = "x-h" ]; then
    echo "Usage: $0 [-h] [-r] [-c CMD...]"
    echo "Runs bash as user www-data in the applicationcron container."
    echo ""
    echo "  -h         Print this message and exit."
    echo "  -r         Run bash as root instead of www-data."
    echo "  -c CMD...  Run given command as user www-data."
    echo "             The whole rest of the command line is interpreted"
    echo "             as the command."
    echo ""
    echo "The options are mutually exclusive, i.e. at most one of them"
    echo "can be specified."
    exit 0
fi

if [ "x$container" = "x" ]; then
    echo "ERROR: Couldn't find container for registry.devgmt.com/gmt/cron-swarm"
    echo "You might be on the wrong node.  Maybe the following output helps to"
    echo "find the right node."
    echo "==> bin/find-service.sh applicationcron"
    bin/find-service.sh applicationcron
    echo "==> Bailing out."
    exit 1
fi

if [ "x$1" = "x-c" ]; then
    shift
    docker exec -it -w /var/www/aio2 $container "$@"
elif [ "x$1" = "x-r" ]; then
    docker exec -it -w /var/www/aio2 $container bash
else
    docker exec -it -u www-data -w /var/www/aio2 $container bash
fi
