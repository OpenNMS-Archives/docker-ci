#!/bin/bash

ARGS=("$@")

TARBALL_COUNT=`ls -1 /data/*.tar.gz | wc -l`
if [ $TARBALL_COUNT -eq 0 ]; then
	cat <<END
ERROR: To use this docker container, you must mount a directory to /data
containing the OpenNMS tarball to compile.

END
	exit 1
fi

if [ $TARBALL_COUNT -gt 1 ]; then
	echo "ERROR: There should be only one OpenNMS tarball in the /data volume.  Found:"
	ls -la /data/*.tar.gz
	echo ""
	exit 1
fi

TARBALL_FILE=`ls -1 /data/*.tar.gz`

set -e
set -x

cd /data

# unpack the OpenNMS tarball
TOPDIR=`tar -tzf "$TARBALL_FILE"  | grep / | sed -e 's,/.*$,,' | head -n 1`
rm -rf "$TOPDIR"
tar -xzf "$TARBALL_FILE"
cd "$TOPDIR"

EXTRA_ARGS=()

if [ -n "$POSTGRES_PORT_5432_TCP_ADDR" ] && [ -n "$POSTGRES_PORT_5432_TCP_PORT" ]; then
	EXTRA_ARGS+=("-Dmock.db.url=jdbc:postgresql://$POSTGRES_PORT_5432_TCP_ADDR:$POSTGRES_PORT_5432_TCP_PORT/")
	EXTRA_ARGS+=("-Dmock.db.adminUser=postgres")
	EXTRA_ARGS+=("-Dmock.db.adminPassword=bamboo")
fi

# build
./compile.pl "$EXTRA_ARGS" "$ARGS"
