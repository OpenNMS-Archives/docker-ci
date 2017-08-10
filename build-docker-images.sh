#!/bin/sh -e

for IMAGE in \
	base-centos \
	base-debian \
	node-centos \
	node-debian \
	nexus \
	itests \
; do
	echo "* Building opennmsbamboo/${IMAGE}"
	rsync -ar ./*.sh ./settings.xml "${IMAGE}/"
	docker build -t "opennmsbamboo/${IMAGE}" "${IMAGE}"
done
