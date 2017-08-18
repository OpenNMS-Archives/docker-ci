#!/bin/bash -e

MYDIR=$(dirname "$0")
MYDIR=$(cd "$MYDIR" || exit 1; pwd)

"${MYDIR}/build-docker-images.sh"

for container in opennms-integration-tests opennms-postgres; do
	docker stop $container || :
	docker rm $container || :
done

SRCDIR="$1"
if [ -z "$SRCDIR" ] || [ ! -d "$SRCDIR" ]; then
	echo "usage: $0 <opennms-source-directory>"
	exit 1
fi

echo docker run --name opennms-postgres -e POSTGRES_PASSWORD=stests -d postgres
docker run --name opennms-postgres -e POSTGRES_PASSWORD=stests -d postgres

if [ `docker ps -q --filter 'name=opennms-nexus' | wc -l` -eq 0 ]; then
	mkdir -p /tmp/nexus-blobs
	chmod 777 /tmp/nexus-blobs
	echo docker run --name opennms-nexus -d -v /tmp/nexus-blobs:/nexus-data/blobs opennmsbamboo/nexus
	docker run -p 8081:8081 --name opennms-nexus -d -v /tmp/nexus-blobs:/nexus-data/blobs opennmsbamboo/nexus
fi

# link the PostgreSQL container
ARGS=("--link" "opennms-postgres:postgres")

# link the Nexus Maven proxy container
ARGS+=("--link" "opennms-nexus:opennms-nexus")

# set sysctl options if Linux is the host
if [ "$(uname -s)" = "Linux" ]; then
	ARGS+=(--sysctl 'net.ipv4.ping_group_range=0 429496729' \
	--sysctl 'net.core.netdev_max_backlog=5000' \
	--sysctl 'net.core.rmem_default=8388608' \
	--sysctl 'net.core.rmem_max=16777216' \
	--sysctl 'net.core.wmem_default=8388608' \
	--sysctl 'net.core.wmem_max=16777216')
fi

# mount the passed to /src and set it to the container working directory
ARGS+=("-v" "${SRCDIR}:/src" "-w" "/src")

# use the opennmsbamboo/itests container
ARGS+=("opennmsbamboo/itests")

# tell docker-cmd.sh to build-in-place
ARGS+=("-b" "/src")

echo docker run -it --name opennms-integration-tests "${ARGS[@]}"
docker run -it --name opennms-integration-tests "${ARGS[@]}"
