#!/bin/bash
container=$(
    docker ps | while read id name dummy; do
        case "$name" in
            registry.devgmt.com/gmt/mariadb-galera-swarm*)
                echo $id
                break
                ;;
        esac
    done
)
if [ "x$container" = "x" ]; then
    echo "ERROR: couldn't find container for registry.devgmt.com/gmt/mariadb-galera-swarm"
    echo "Bailing out."
    exit 1
fi
mydir=$(dirname $0)
if [ "x$1" = "x-h" ]; then
    echo "Usage: $0 [-h] [-s]"
    echo "With '-h', print this error message."
    echo "With '-s', run bash instead of mysql."
    echo "Otherwise, log mysql as the mysql root user."
elif [ "x$1" = "x-s" ]; then
    docker exec -it $container bash
else
    docker exec -it $container mysql -p$( cat $mydir/../.secrets/mysql_root_password )
fi
