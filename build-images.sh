#!/bin/bash -e

(docker rm $(docker ps -aq)) || :
(docker rmi $(docker images --filter dangling=true --quiet)) || :

for IMAGE in \
	opennms-base-rpm \
	opennms-base-deb \
	opennms-compile-debhost \
	opennms-installer-debhost \
; do
	rsync -ar --delete init.d/ "$IMAGE"/init.d/
	docker build -t "$IMAGE" "$IMAGE"
done
