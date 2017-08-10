#!/bin/sh -e

./build-docker-images.sh

for IMAGE in \
	base-centos \
	base-debian \
	node-centos \
	node-debian \
	nexus \
	itests \
; do
	echo "* Deploying opennmsbamboo/${IMAGE} to Docker Hub"
	docker push "opennmsbamboo/${IMAGE}"
done
