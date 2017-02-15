#!/bin/sh -e

./build-docker-images.sh

for container in opennms-integration-tests opennms-postgres; do
	docker stop $container || :
	docker rm $container || :
done
docker run --name opennms-postgres -e POSTGRES_PASSWORD=stests -d postgres
docker run --name opennms-integration-tests --link opennms-postgres:postgres opennms/itests "$@"
