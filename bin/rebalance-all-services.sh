#!/bin/bash
nservices=$(docker service ls -q | wc -l)

declare -i iservice
iservice=1
docker service ls | while read id name mode replicas y z; do
    if [ "x$id" = "xID" ]; then
        # header line
        continue
    fi
    echo ""
    echo "==> Service $iservice/$nservices: $name"
    echo ""
    iservice=$((1 + $iservice))
    if [ "x$mode" = "xglobal" ]; then
        echo "Mode is global, skipping"
        continue
    fi
    case "$replicas" in
        0/*)
            echo "Service currently down, skipping"
            continue
            ;;
    esac
    docker service update --force $name
done

echo ""
echo "==> ALL DONE"

