#!/bin/sh -e

for IMAGE in \
	opennms-base-rpm \
	opennms-base-deb \
	opennms-build-deb \
; do
	rsync -avr scripts/ "${IMAGE}/common-scripts/"
	docker build -t "$IMAGE" "$IMAGE"
done
