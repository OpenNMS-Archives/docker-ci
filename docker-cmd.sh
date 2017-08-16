#!/bin/bash

set -o pipefail

usage() {
	echo "usage: $0 <-b workdir | git_url git_branch [git_commit] [workdir]>"
	echo ""
	echo "	-b   Enable build-in-place mode.  This assumes that the git repository is checked out to the specified working directory."
	echo ""
	exit 1
}

install_packages() {
	echo "* installing packages"
	if [ -x /usr/bin/apt-get ]; then
		#apt-get update
		#apt-get -y install sudo postgresql-client "r-recommended" "openssh-server" "ruby"
		systemctl restart ssh
	elif [ -x /usr/bin/yum ]; then
		#yum -y install sudo postgresql "epel-release" "openssh-server" "ruby" "rubygems"
		#yum -y install R
		systemctl restart sshd
	else
		echo "no apt-get nor yum, not sure what to do"
		exit 1
	fi
	#gem install sass
}


echo "command:" "$0" "$@"
BUILD_IN_PLACE=0
WORKDIR="/src"
GIT_URL="https://github.com/OpenNMS/opennms.git"
GIT_BRANCH="develop"
GIT_COMMIT="develop"
declare ARGS=()

while getopts bu: OPT; do
	case $OPT in
		b) BUILD_IN_PLACE=1
			ARGS+=('-b')
			;;
	esac
done

if [ "$BUILD_IN_PLACE" -eq 1 ]; then
	shift
	WORKDIR="$1"
	ARGS+=("$WORKDIR")
	if [ -z "${WORKDIR}" ]; then
		usage
	fi
else
	GIT_URL="$1"
	GIT_BRANCH="$2"
	GIT_COMMIT="$3"
	if [ -z "${GIT_BRANCH}" ]; then
		usage
	fi
	if [ -z "${GIT_COMMIT}" ] ;then
		GIT_COMMIT="${GIT_BRANCH}"
	fi

	ARGS+=("$GIT_URL" "$GIT_BRANCH" "$GIT_COMMIT")
	if [ -n "$4" ]; then
		WORKDIR="$4"
	fi
fi

mkdir -p "${WORKDIR}"
cd "$WORKDIR" || exit 1

NEXUS_HOST="${OPENNMS_NEXUS_PORT_8081_TCP_ADDR}"
NEXUS_PORT="${OPENNMS_NEXUS_PORT_8081_TCP_PORT}"
SETTINGS_XML="/tmp/settings.xml"

if [ -e /settings.xml ]; then
	echo "* creating ${SETTINGS_XML}"
	mkdir -p "${WORKDIR}"
	sed -e "s,localhost:8081,${NEXUS_HOST}:${NEXUS_PORT},g" /settings.xml > "${SETTINGS_XML}"
else
	echo "* ERROR: no settings.xml found, this image has gone squirrely"
	exit 1
fi

if [ -f .git/HEAD ]; then
	# shellcheck disable=SC2012
	HOST_UID="$(ls -lan .git/HEAD | awk '{ print $3 }')"
fi

echo "HOST_UID=${HOST_UID}"
echo "UID=$(id -u)"

if [ -n "$HOST_UID" ] && [ "$(id -u)" -ne "$HOST_UID" ]; then
	install_packages
	SUDO="$(which sudo)"
	"$SUDO" -u "#${HOST_UID}" -E /usr/bin/env HOST_UID="${HOST_UID}" HOME="${HOME}" WORKDIR="${WORKDIR}" "$0" "${ARGS[@]}" || exit $?
	exit 0
elif [ -z "$HOST_UID" ]; then
	if [ "$BUILD_IN_PLACE" -eq 1 ]; then
		echo "ERROR: setting \$HOST_UID is required in build-in-place mode."
		exit 1
	else
		echo "WARNING: \$HOST_UID is not set!"
	fi
	install_packages
fi

if [ "$BUILD_IN_PLACE" -eq 1 ]; then
	echo "building in place: $WORKDIR"
else
	echo "building repo ${GIT_URL} from branch ${GIT_BRANCH} (${GIT_COMMIT})"
fi

echo "* docker environment:"
env

export PGPASSWORD="${OPENNMS_POSTGRES_ENV_POSTGRES_PASSWORD}"
if [ -z "${PGPASSWORD}" ]; then
	PGPASSWORD="${POSTGRES_ENV_POSTGRES_PASSWORD}"
fi

export PGHOST="${OPENNMS_POSTGRES_PORT_5432_TCP_ADDR}"
if [ -z "${PGHOST}" ]; then
	PGHOST="${POSTGRES_PORT_5432_TCP_ADDR}"
fi

export PGPORT="${OPENNMS_POSTGRES_PORT_5432_TCP_PORT}"
if [ -z "${PGPORT}" ]; then
	PGPORT="${POSTGRES_PORT_5432_TCP_PORT}"
fi

/wait-for-postgres.sh || exit 1
/wait-for-nexus.sh || exit 1

echo "* setting up opennms user"
psql \
	-h "${PGHOST}" \
	-p "${PGPORT}" \
	-U postgres \
	-c "CREATE USER opennms CREATEDB SUPERUSER LOGIN PASSWORD 'opennms';" \
	|| exit 1

if [ "$BUILD_IN_PLACE" -eq 0 ]; then
	echo "* cloning $GIT_URL:"
	git clone --depth 1 --branch "$GIT_BRANCH" "$GIT_URL" . || exit 1
	git reset --hard "$GIT_COMMIT" || exit 1
fi
git clean -fdx || exit 1
git branch
git log | head -n 10

echo "* fixing opennms-datasources.xml files for testing"
find . -type f -name opennms-datasources.xml | while read -r FILE; do
	sed -e "s,localhost:5432,${PGHOST}:${PGPORT},g" -e "s,\${install.database.admin.user},postgres,g" -e "s,\${install.database.admin.password},${PGPASSWORD},g" "${FILE}" > "${FILE}.replaced"
	mv "${FILE}.replaced" "${FILE}"
done

if [ -e /blacklist-files.txt ]; then
	echo "* removing blacklisted files:"
	(while read -r FILE; do
		if [ -n "$FILE" ] && [ -r "$FILE" ]; then
			echo "  * blacklisted: $FILE"
			rm -f "$FILE"
		else
			echo "  * not found: $FILE"
		fi
	done) < /blacklist-files.txt
else
	echo "* blacklist not found"
fi

echo "* building in $WORKDIR:"

echo ./compile.pl -s "${SETTINGS_XML}" -Dbuild.skip.tarball=true -N help:effective-settings
./compile.pl -s "${SETTINGS_XML}" -Dbuild.skip.tarball=true -N help:effective-settings

# heartbeat  :)
(while true; do sleep 5; date; done) &

COMPILE_CMD=(./compile.pl \
	"-Dorg.opennms.core.test-api.snmp.useMockSnmpStrategy=false" \
	"-DupdatePolicy=never" \
	"-Dmock.db.url=jdbc:postgresql://${PGHOST}:${PGPORT}/" \
	"-Dmock.db.adminUser=postgres" \
	"-Dmock.db.adminPassword=${PGPASSWORD}" \
	"-DrunPingTests=false" \
	"-DskipIpv6Tests=true" \
	"-Dbuild.skip.tarball=true" \
	-v \
	-Pbuild-bamboo \
	-s "${SETTINGS_XML}")

# run tests
echo "${COMPILE_CMD[@]}" -t install
"${COMPILE_CMD[@]}" -t install 2>&1 | tee output.log | grep -E '(Running org|Tests run: )'

RET="$?"

if [ "$RET" -gt 0 ]; then
	echo "BUILD FAILED."
	echo "Here are the last 10k lines of the logs.  If you need more, get the 'output.log' artifact from Bamboo."
	echo "-----"
	tail -n 10000 output.log
fi

exit "$RET"
