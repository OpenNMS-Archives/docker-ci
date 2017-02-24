#!/bin/sh -e

./build-docker-images.sh
docker push opennmsbamboo/itests
