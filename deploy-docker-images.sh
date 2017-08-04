#!/bin/sh -e

./build-docker-images.sh
docker push opennmsbamboo/itests
docker push opennmsbamboo/node-centos
docker push opennmsbamboo/node-debian
