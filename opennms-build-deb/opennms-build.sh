#!/bin/sh

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

# build
./compile.pl -Dmaven.test.skip.exec=true

# build javadoc
./compile.pl -Dmaven.test.skip.exec=true javadoc:aggregate
