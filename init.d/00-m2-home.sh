#!/bin/bash -e

if [ -d /data/m2 ]; then
	rsync -avr /data/m2/ ~/.m2/
fi
