#!/bin/sh

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

COUNT=1
while [ $COUNT -lt 120 ]; do
	echo "waiting for postgres: try #${COUNT}"
	echo "password=${PGPASSWORD}, host=${PGHOST}:${PGPORT}"
	COUNT="$((COUNT + 1))"
	if PGPASSWORD="${PGPASSWORD}" psql -q -h "${PGHOST}" -p "${PGPORT}" -U "postgres" -c "select true;" >/dev/null; then
		echo "postgres is ready"
		exit 0
	fi
	sleep 1
done

echo "postgres never got ready :("
exit 1
