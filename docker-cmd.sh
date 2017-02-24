#!/bin/sh -x

echo "command:" "$@"
if [ -z "$3" ]; then
	echo "usage: $0 <git_url> <git_branch> <git_commit> [builddir]"
	exit 1
fi

GIT_URL="$1"
GIT_BRANCH="$2"
GIT_COMMIT="$3"
BUILDDIR="$4"

if [ -z "$BUILDDIR" ]; then
	BUILDDIR="/src"
fi
rm -rf "$BUILDDIR"
mkdir -p "$BUILDDIR"
cd "$BUILDDIR" || exit 1

echo "* docker environment:"
env

echo "* installing psql"
if [ -x /usr/bin/apt-get ]; then
	apt-get update
	apt-get -y install postgresql-client
elif [ -x /usr/bin/yum ]; then
	yum -y install postgresql
else
	echo "no apt-get nor yum, not sure what to do"
fi
/wait-for-postgres.sh

echo "* cloning $GIT_URL:"
git clone --depth 1 --branch "$GIT_BRANCH" "$GIT_URL" . || exit 1
git reset --hard "$GIT_COMMIT" || exit 1

echo "* building in $BUILDDIR:"

# run compile
echo ./compile.pl \
	-Dorg.opennms.core.test-api.snmp.useMockSnmpStrategy=false \
	-DupdatePolicy=never \
	-Dmock.db.url="jdbc:postgresql://${OPENNMS_POSTGRES_PORT_5432_TCP_ADDR}:${OPENNMS_POSTGRES_PORT_5432_TCP_PORT}/" \
	-Dmock.db.adminUser="postgres" \
	-Dmock.db.adminPassword="${OPENNMS_POSTGRES_ENV_POSTGRES_PASSWORD}" \
	-t \
	-v \
	-Pbuild-bamboo \
	install
./compile.pl \
	-Dorg.opennms.core.test-api.snmp.useMockSnmpStrategy=false \
	-DupdatePolicy=never \
	-Dmock.db.url="jdbc:postgresql://${OPENNMS_POSTGRES_PORT_5432_TCP_ADDR}:${OPENNMS_POSTGRES_PORT_5432_TCP_PORT}/" \
	-Dmock.db.adminUser="postgres" \
	-Dmock.db.adminPassword="${OPENNMS_POSTGRES_ENV_POSTGRES_PASSWORD}" \
	-t \
	-v \
	-Pbuild-bamboo \
	install

RET=$?

find ./* -type d -print0 -name surefire-reports -o -name failsafe-reports | xargs -0 tar -cvzf junit-output.tar.gz

exit $RET
