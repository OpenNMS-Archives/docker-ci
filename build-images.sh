#!/bin/sh -e

for IMAGE in \
	opennms-base-rpm \
	opennms-base-deb \
	opennms-build-deb \
	opennms-installer-deb \
; do
	docker build -t "$IMAGE" "$IMAGE"
done
