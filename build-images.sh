#!/bin/bash -e

(docker rm $(docker ps -a -q)) || :
(docker images --no-trunc | grep none | awk '{ print $3 }' | xargs docker rmi) || :

for IMAGE in \
	opennms-base-rpm \
	opennms-base-deb \
	opennms-compile-debhost \
	opennms-installer-debhost \
; do
	rsync -ar --delete init.d/ "$IMAGE"/init.d/
	docker build -t "$IMAGE" "$IMAGE"
done
