#!/bin/bash

docker node update --label-add dbnodegalera=1 gmt-prod-1 
docker node update --label-add dbseedgalera=0 gmt-prod-1
