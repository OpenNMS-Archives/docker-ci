#!/bin/sh -e

ORIGDIR="$(pwd)"
MYDIR=$(dirname "$0")
MYDIR=$(cd "$MYDIR" || exit 1; pwd)

cd "${MYDIR}"

for IMAGE in \
	base-centos \
	base-debian \
	node-centos \
	node-debian \
	build-centos \
	nexus \
	itests \
; do
	echo "* Building opennmsbamboo/${IMAGE}"
	rsync -ar ./*.sh ./settings.xml "${IMAGE}/"
	docker build -t "opennmsbamboo/${IMAGE}:develop" "${IMAGE}"
done

cd "${ORIGDIR}"
