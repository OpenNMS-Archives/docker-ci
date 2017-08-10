#!/bin/bash -e

./build-docker-images.sh

for container in opennms-integration-tests opennms-postgres opennms-nexus; do
	docker stop $container || :
	docker rm $container || :
done

echo docker run --name opennms-postgres -e POSTGRES_PASSWORD=stests -d postgres
docker run --name opennms-postgres -e POSTGRES_PASSWORD=stests -d postgres

echo docker run --name opennms-nexus -d opennmsbamboo/nexus
docker run -p 8081:8081 --name opennms-nexus -d opennmsbamboo/nexus

ARGS=("--link" "opennms-postgres:postgres" "--link" "opennms-nexus:opennms-nexus")
if [ "$(uname -s)" = "Linux" ]; then
	ARGS+=(--sysctl 'net.ipv4.ping_group_range=0 429496729' \
	--sysctl 'net.core.netdev_max_backlog=5000' \
	--sysctl 'net.core.rmem_default=8388608' \
	--sysctl 'net.core.rmem_max=16777216' \
	--sysctl 'net.core.wmem_default=8388608' \
	--sysctl 'net.core.wmem_max=16777216')
fi
ARGS+=("opennmsbamboo/itests")

echo docker run -it --name opennms-integration-tests "${ARGS[@]}" "$@"
docker run -it --name opennms-integration-tests "${ARGS[@]}" "$@"
