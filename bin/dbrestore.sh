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
passwd=$( cat $mydir/../.secrets/mysql_root_password )
docker exec -i $container mysql "-p$passwd" prod < prod.sql
