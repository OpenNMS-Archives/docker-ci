#!/bin/sh -e

./build-docker-images.sh

for container in opennms-integration-tests opennms-postgres; do
	docker stop $container || :
	docker rm $container || :
done
docker run --name opennms-postgres -e POSTGRES_PASSWORD=stests -d postgres
docker run --name opennms-integration-tests \
	--link opennms-postgres:postgres \
	--sysctl 'net.ipv4.ping_group_range=0 429496729' \
	--sysctl 'net.core.netdev_max_backlog=5000' \
	--sysctl 'net.core.rmem_default=8388608' \
	--sysctl 'net.core.rmem_max=16777216' \
	--sysctl 'net.core.wmem_default=8388608' \
	--sysctl 'net.core.wmem_max=16777216' \
	opennmsbamboo/itests \
	"$@"
