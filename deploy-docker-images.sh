#!/bin/sh -e

./build-docker-images.sh

for IMAGE in \
	base-centos \
	base-debian \
	itests \
	node-centos \
	node-debian \
; do
	echo "* Deploying opennmsbamboo/${IMAGE} to Docker Hub"
	docker push "opennmsbamboo/${IMAGE}"
done
