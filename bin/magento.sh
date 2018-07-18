#!/bin/bash
container=$(
    docker ps | while read id name dummy; do
        case "$name" in
            registry.devgmt.com/gmt/php-swarm*)
            echo $id
            break
                ;;
        esac
    done
)

if [ "x$1" = "x-h" ]; then
    echo "Usage: $0 [-h] [-r] [-c CMD...]"
    echo "Runs bash as user www-data in the applicationphp container."
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
    echo "ERROR: Couldn't find container for registry.devgmt.com/gmt/php-swarm"
    echo "Maybe it is not running on this node."
    echo "Running \'bin/find-service.sh applicationphp\' to find it."
    bin/find-service.sh applicationphp
    echo "Bailing out."
    exit 1
fi

if [ "x$1" = "x-c" ]; then
    shift
    docker exec -it $container "$@"
elif [ "x$1" = "x-r" ]; then
    docker exec -it $container bash
else
    docker exec -it -u www-data $container bash
fi
