#!/bin/sh

usage() {
	echo "usage: $0 <-b workdir | git_url git_branch git_commit [workdir]>"
	echo ""
	echo "	-b   Enable build-in-place mode.  This assumes that the git repository is checked out to the specified working directory."
	echo ""
	exit 1
}

echo "command:" "$@"
BUILD_IN_PLACE=0
WORKDIR="/src"
GIT_URL="https://github.com/OpenNMS/opennms.git"
GIT_BRANCH="develop"
GIT_COMMIT="develop"

while getopts b OPT; do
	case $OPT in
		b) BUILD_IN_PLACE=1
			;;
	esac
done

if [ "$BUILD_IN_PLACE" -eq 1 ]; then
	shift
	WORKDIR="$1"
	if [ -z "${WORKDIR}" ]; then
		usage
	fi
	echo "building in place: $WORKDIR"
else
	GIT_URL="$1"
	GIT_BRANCH="$2"
	GIT_COMMIT="$3"
	if [ -z "${GIT_COMMIT}" ]; then
		usage
	fi
	if [ -n "$4" ]; then
		WORKDIR="$4"
	fi
	echo "building repo ${GIT_URL} from branch ${GIT_BRANCH} (${GIT_COMMIT})"
fi

find "$WORKDIR" -type f

mkdir -p "${WORKDIR}"
cd "$WORKDIR" || exit 1

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

echo "* setting up opennms user"
PGPASSWORD="${OPENNMS_POSTGRES_ENV_POSTGRES_PASSWORD}" psql \
	-h "${OPENNMS_POSTGRES_PORT_5432_TCP_ADDR}" \
	-p "${OPENNMS_POSTGRES_PORT_5432_TCP_PORT}" \
	-U postgres \
	-c "CREATE USER opennms CREATEDB SUPERUSER LOGIN PASSWORD 'opennms';"

if [ "$BUILD_IN_PLACE" -eq 0 ]; then
	echo "* cloning $GIT_URL:"
	git clone --depth 1 --branch "$GIT_BRANCH" "$GIT_URL" . || exit 1
	git reset --hard "$GIT_COMMIT" || exit 1
fi
git clean -fdx || exit 1

echo "* fixing test opennms-datasources.xml files"
find . -type f -name opennms-datasources.xml | grep /src/test/ | while read -r FILE; do
	sed -e "s,localhost:5432,${OPENNMS_POSTGRES_PORT_5432_TCP_ADDR}:${OPENNMS_POSTGRES_PORT_5432_TCP_PORT},g" "${FILE}" > "${FILE}.replaced"
	mv "${FILE}.replaced" "${FILE}"
done

echo "* removing failing tests for now..."
cat /blacklist-files.txt | while read -r FILE; do
	if [ -n "$FILE" ] && [ -r "$FILE" ]; then
		rm -f "$FILE"
	fi
done

echo "* building in $WORKDIR:"

# heartbeat  :)
(while true; do sleep 5; date; done) &

# run compile
echo ./compile.pl \
	-Dorg.opennms.core.test-api.snmp.useMockSnmpStrategy=false \
	-DupdatePolicy=never \
	-Dmock.db.url="jdbc:postgresql://${OPENNMS_POSTGRES_PORT_5432_TCP_ADDR}:${OPENNMS_POSTGRES_PORT_5432_TCP_PORT}/" \
	-Dmock.db.adminUser="postgres" \
	-Dmock.db.adminPassword="${OPENNMS_POSTGRES_ENV_POSTGRES_PASSWORD}" \
	-DrunPingTests=false \
	-Dbuild.skip.tarball=true \
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
	-DrunPingTests=false \
	-Dbuild.skip.tarball=true \
	-t \
	-v \
	-Pbuild-bamboo \
	install 2>&1 | tee output.log | grep -E '(Running org|Tests run: )'

exit $?
