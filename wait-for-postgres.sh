#!/bin/sh

COUNT=1
while [ $COUNT -lt 120 ]; do
	echo "waiting for postgres: try #${COUNT}"
	COUNT="$((COUNT + 1))"
	if PGPASSWORD="${OPENNMS_POSTGRES_ENV_POSTGRES_PASSWORD}" psql -q -h "${OPENNMS_POSTGRES_PORT_5432_TCP_ADDR}" -p "${OPENNMS_POSTGRES_PORT_5432_TCP_PORT}" -U "postgres" -c "select true;" >/dev/null; then
		echo "postgres is ready"
		exit 0
	fi
	sleep 1
done

echo "postgres never got ready :("
echo "let's try anyways..."
exit 0
