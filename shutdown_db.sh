#!/bin/bash

docker node update --label-add dbnodegalera=0 test1
docker node update --label-add dbnodegalera=0 test2
docker node update --label-add dbnodegalera=0 test3

