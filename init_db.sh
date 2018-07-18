#!/bin/bash

docker node update --label-add dbnodegalera=0 gmt-prod-1
docker node update --label-add dbnodegalera=0 gmt-prod-2
docker node update --label-add dbnodegalera=0 gmt-prod-3
docker node update --label-add dbseedgalera=1 gmt-prod-1
