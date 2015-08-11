#!/bin/bash -e

if [ -d /data/m2 ]; then
	rsync -avr /data/m2/ ~/.m2/
else
	echo "WARNING: no /data/m2 directory found; you will not be able to sign jars"
fi
