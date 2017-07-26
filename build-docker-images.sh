#!/bin/sh -e

for IMAGE in itests stests; do
	rsync -ar *.sh $IMAGE/
	docker build -t opennmsbamboo/$IMAGE $IMAGE
done
