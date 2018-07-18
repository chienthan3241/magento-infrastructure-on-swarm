#!/bin/bash

echo "==> (1/3) Restarting magento_fullpagecachevarnish"
docker service update --force magento_fullpagecachevarnish
echo ""

echo "==> (2/3) Restarting  magento_cacheredismaster"
docker service update --force magento_cacheredismaster
echo ""

echo "==> (3/3) Restarting  magento_cacheredisslave"
docker service update --force magento_cacheredisslave
echo ""

echo "All done."
