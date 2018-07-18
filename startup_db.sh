#!/bin/bash

docker node update --label-add dbnodegalera=1 gmt-prod-2
docker node update --label-add dbnodegalera=1 gmt-prod-3
