#!/bin/sh -e

for IMAGE in \
	base-centos \
	base-debian \
	itests \
	node-centos \
	node-debian \
; do
	echo "* Building opennmsbamboo/${IMAGE}"
	rsync -ar ./*.sh "${IMAGE}/"
	docker build -t "opennmsbamboo/${IMAGE}" "${IMAGE}"
done
