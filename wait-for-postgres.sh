#!/bin/sh

COUNT=1
while [ $COUNT -lt 120 ]; do
	echo "waiting for postgres: try #${COUNT}"
	PGPASSWORD="${OPENNMS_POSTGRES_ENV_POSTGRES_PASSWORD}" psql -q -h "${OPENNMS_POSTGRES_PORT_5432_TCP_ADDR}" -p "${OPENNMS_POSTGRES_PORT_5432_TCP_PORT}" -U "postgres" -c "select true;" >/dev/null
	if [ $? -eq 0 ]; then
		echo "postgres is ready"
		exit 0
	fi
	sleep 1
	COUNT=`expr $COUNT + 1`
done

echo "postgres never got ready :("
echo "let's try anyways..."
exit 0
