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

echo "==> (1/4) bin/magento setup:upgrade"
docker exec -u www-data $container php bin/magento setup:upgrade
echo ""

echo "==> (2/4) bin/magento setup:di:compile"
docker exec -u www-data $container php bin/magento setup:di:compile
echo ""

echo "==> (3/4) bin/magento setup:static-content:deploy de_DE en_US"
docker exec -u www-data $container php bin/magento setup:static-content:deploy de_DE en_US
echo ""

echo "==> (4/4) copy js-translation.json"
docker exec -u www-data $container \
    cp app/i18n/de_DE_Germantom/pub/static/frontend/TemplateMonster/theme007/de_DE/js-translation.json \
        pub/static/frontend/TemplateMonster/theme007/de_DE/ 
echo ""

echo "All done."
