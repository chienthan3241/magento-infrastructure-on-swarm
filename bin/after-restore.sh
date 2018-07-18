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

if [ "x$container" = "x" ]; then
    echo "ERROR: Couldn't find container for registry.devgmt.com/gmt/php-swarm"
    echo "Maybe `docker service update --force magento_applicationphp` will fix it."
    echo "Try that, then try again.  If that doesn't help, ask yourself why"
    echo "is that service not running on this host."
    echo "Bailing out."
    exit 1
fi

case "$1" in
    prod)
	docker exec -u www-data $container php bin/magento setup:store-config:set \
	       --base-url=http://www.germantom.com/ \
	       --base-url-secure=https://www.germantom.com/
	;;
    staging)
	docker exec -u www-data $container php bin/magento setup:store-config:set \
	       --base-url=http://staging.devgmt.com/ \
	       --base-url-secure=https://staging.devgmt.com/
	;;
    help)
	echo "Usage: $0 <environment>"
	echo "<environment> can be 'prod' or 'staging'."
	exit 0
	;;
    *)
	echo "ERROR: Usage: $0 <environment>"
	echo "<environment> can be 'prod' or 'staging'."
	;;
esac
