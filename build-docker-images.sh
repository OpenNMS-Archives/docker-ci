#!/bin/sh -e

for IMAGE in itests stests node-centos node-debian; do
	rsync -ar ./*.sh $IMAGE/
	docker build -t opennmsbamboo/$IMAGE $IMAGE
done
