#!/bin/bash -e

if [ -d /data/gnupg ]; then
	rsync -ar /data/gnupg/ ~/.gnupg/
	chmod 700 ~/.gnupg/
	chmod go-rwx ~/.gnupg/*
fi
