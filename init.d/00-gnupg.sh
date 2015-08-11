#!/bin/bash -e

if [ -d /data/gnupg ]; then
	rsync -ar /data/gnupg/ ~/.gnupg/
	chmod 700 ~/.gnupg/
	chmod go-rwx ~/.gnupg/*
else
	echo "WARNING: no /data/gnupg directory found; you will not be able to sign packages"
fi
