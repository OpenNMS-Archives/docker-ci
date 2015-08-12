#!/bin/bash -e

for IMAGE in \
	opennms-base-rpm \
	opennms-base-deb \
	opennms-compile-debhost \
	opennms-installer-debhost \
; do
	echo "=== ${IMAGE} ==="
	rsync -ar --delete init.d/ "$IMAGE"/init.d/
	if [ -e "${IMAGE}.built" ]; then
		NEWFILES=`find "${IMAGE}" -type f -newer "${IMAGE}.built" | wc -l`
		if [ $NEWFILES -eq 0 ]; then
			continue
		fi
	fi
	docker build -t "$IMAGE" "$IMAGE"
	touch "${IMAGE}.built"
done
