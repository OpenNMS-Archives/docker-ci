#!/bin/sh -e

for IMAGE in \
	base-centos \
	base-debian \
	node-centos \
	node-debian \
	itests \
; do
	echo "* Building opennmsbamboo/${IMAGE}"
	rsync -ar ./*.sh "${IMAGE}/"
	docker build -t "opennmsbamboo/${IMAGE}" "${IMAGE}"
done
