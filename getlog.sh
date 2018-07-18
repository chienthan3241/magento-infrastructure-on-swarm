#!/bin/bash

#journalctl -u docker CONTAINER_NAME=mycontainer_name

journalctl -u docker CONTAINER_TAG=$1
