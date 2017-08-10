#!/bin/sh

NEXUS_HOST="${OPENNMS_NEXUS_PORT_8081_TCP_ADDR}"
NEXUS_PORT="${OPENNMS_NEXUS_PORT_8081_TCP_PORT}"

COUNT=1
while [ $COUNT -lt 120 ]; do
	echo "waiting for nexus: try #${COUNT}: http://${NEXUS_HOST}:${NEXUS_PORT}/"
	COUNT="$((COUNT + 1))"
	if curl -u admin:admin123 "http://${NEXUS_HOST}:${NEXUS_PORT}/service/metrics/ping" >/dev/null 2>&1; then
		echo "nexus is ready"
		exit 0
	fi
	sleep 1
done

echo "nexus never got ready :("
exit 1
